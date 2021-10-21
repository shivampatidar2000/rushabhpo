FROM ruby:2.6.5-alpine
ARG RAILS_ENV=production
ENV RAILS_ENV="${RAILS_ENV}"
ENV APP_VERSION=${TAG}
RUN apk update
RUN apk add bash build-base libxml2-dev libxslt-dev postgresql postgresql-dev nodejs vim yarn libc6-compat curl git which wkhtmltopdf ttf-ubuntu-font-family imagemagick
RUN mkdir /app
WORKDIR /app
COPY template-app/Gemfile* ./
RUN gem install bundler && bundle config https://gem.fury.io/engineerai/ nvHuX-OXxLY2OpiQkFVfgnYgd4CszdA
RUN bundle install
COPY template-app/ .
EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
