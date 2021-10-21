module BxBlockOrderManagement
  class UpdatePayment
    include Wisper::Publisher

    attr_accessor :params, :payment_status, :schedule_time, :transaction_id, :order, :user

    ENTITYID = "8ac7a4c874672c64017468b0fdcf0756"

    def initialize(params, order)
      @params = params
      @payment_status = params[:status]
      @schedule_time = params[:schedule_time]
      @transaction_id = params[:transaction_id]
      @order = order
      @user = order.account
    end

    def call
      hyperpay_response = broadcast(
        :payment_hyperpay_get_status,
        transaction_id,
        ("?entityId=#{ENTITYID}")
      )
      unless hyperpay_response.respond_to? :values
        return OpenStruct.new(success?: false, msg: 'No Hyperspace integration found', code: 208)
      end

      @response = hyperpay_response.values.first
      if payment_status == 'success'
        proccess_after_payment
      elsif payment_status == 'pending'
        process_pending_order 'pending_order'
        return OpenStruct.new(
          success?: false, msg: I18n.t('messages.after_payments.internal_error'), code: 400
        )
      elsif payment_status == 'failed'
        process_pending_order 'payment_failed'
        return OpenStruct.new(
          success?: false, msg: I18n.t('messages.after_payments.status_fail'), code: 400
        )
      else
        return OpenStruct.new(success?: false, msg: 'Sorry, Something went wrong', code: 208)
      end
    end

    def handle_other_model_attribtues
      ActiveRecord::Base.transaction do
        update_order_record
        create_transaction
        update_product_attributes
      end
      OpenStruct.new(success?: true, msg: 'All attributes updated successfully', code: 200)
    rescue ActiveRecord::Rollback
      OpenStruct.new(
        success?: false, msg: I18n.t('messages.after_payments.internal_error'), code: 400
      )
    rescue ActiveRecord::RecordNotFound
      OpenStruct.new(
        success?: false, msg: I18n.t('messages.after_payments.internal_error'), code: 400
      )
    end

    def proccess_after_payment
      result = handle_other_model_attribtues
      if result.success?
        shipment_params = BxBlockFedexIntegration::ShipmentAttributesCreation.new(
          order, @response
        ).call
        shipment_service = BxBlockFedexIntegration::ShipmentService.new
        result = shipment_service.create(shipment_params)
        if result['status'] == "PROPOSED"
          order.update!(
            shipment_id: result['id'],
            tracking_url: result['trackingURL'],
            tracking_number: result['waybill']
          )
          order.confirm_order!
          update_order_item_status
          OpenStruct.new(
            success?: true,
            msg: I18n.t('messages.deliveries.success', deliver_by: "FedEx"),
            code: 200
          )
        else
          error = I18n.t('messages.deliveries.failed') +  "Error from #{order.deliver_by} "
          OpenStruct.new(success?: false, msg: error, code: 400)
        end
        OpenStruct.new(
          success?: true,
          msg: I18n.t('messages.deliveries.success', deliver_by: "FedEx"),
          code: 200
        )
      else
        OpenStruct.new(success?: false, msg: result.msg, code: 400)
      end
    end

    private

    def process_pending_order req_type
      order.update!(
        order_date: Time.current,
        is_gift: params[:is_gift],
        source: params[:source],
        schedule_time: schedule_time
      )
      order.send("#{req_type}!")
      create_transaction
    end

    def update_order_record
      order.update!(
        order_date: Time.current,
        is_gift: params[:is_gift],
        source: params[:source],
        schedule_time: schedule_time
      )
      order.place_order!
    end

    def create_transaction
      OrderTransaction.create!(
        charge_id: transaction_id,
        amount: @response['data']['amount'].to_i,
        currency: @response['data']['currency'],
        order_id: order.id,
        account_id: user.id,
        charge_status: payment_status
      )
    end

    def update_product_attributes
      order.order_items.each do |oi|
        product = oi.catalogue
        product.update_attributes(sold: (product.sold + oi.quantity))
        status = oi.order.status
        oi.update("#{status}_at".to_sym => oi.order.send("#{status}_at"), :status => status)
      end
    end

    def update_order_item_status
      order.order_items.each do |oi|
        status = oi.order.status
        oi.update("#{status}_at".to_sym => oi.order.send("#{status}_at"), :status => status)
      end
    end

  end
end
