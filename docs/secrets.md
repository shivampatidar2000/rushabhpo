# Secrets Management

# About

Helm charts often require sensitive data for the application to install and function properly, these can be passwords, keys or certificates. To be able to mange and version those along with the rest of the configuration your chart needs it has to be encrypted prior being committed to the repository. We accomplish this by use of [Helm secrets](https://github.com/zendesk/helm-secrets) and [Sops](https://github.com/mozilla/sops) (which the Helm plugin depends on too which in turn depends on [GPG](https://gnupg.org/))


# Encryption keys

The private key paired with the public key in this repo is not widely distributed. If you use it, you may not be able to decrypt encrytped files locally.  
For projects under the gitlab namespace "client project", the supplied key must be used. Contact an administrator to decrypt files.

In other use cases you may use a key pair of your choice.  
Simply add your ascii armoured private key to the gitlab CI variable `GPG_KEY_APP`. 
Export key:  
`gpg --export-secret-keys --armor [fingerprint] > /tmp/private.key`

# Step by step usage

1. Download SOPS for you platform form [here](https://gitlab.builder.ai/public-tools/repo-tools/tree/master/sops/bin) and unpack it (gzip).

2.  Import the pgp public key in the `app-deploy` directory.  

```bash
cd app-deploy
gpg --import template-app-key-pub.gpg
```

3. Create the secrets yaml file in the `app-deploy` directory.  

  - The file must be called values-secrets.yaml, values-stage-secrets.yaml and values-prod-secrets.yaml for dev, stage and prod respectively.  

  - To create the file, run :

```bash
sops --pgp 4C80959A5A0DC7D784CEDE1E1B7F34C12F7B86BE values-stage-secrets.yaml
```

If you don't have the fingerprint id, you can get it with 
```bash
gpg --list-secret-keys
```

You may also need to set your editor variable if it does not open :  
`export EDITOR=vi`

4. Edit the contents of the file to look like this : 

```yaml
appExtConfig:
    secretStage: hello-world-stage-new
    MySecret: secret
```

They key name *must* be **appExtConfig**  

Save the file and exit.

Verify the contents, it should look like this :  
```yaml
appExtConfig:
    secretStage: ENC[AES256_GCM,data:kfpvQqaezIWs/eb2Q4NAVb5HRW40,iv:x65hdmItrErv6EuAmsWlKdbRVGcYJ1quPF3ECCr7ctU=,tag:0UNrmM9X2WA75DGWenSFbw==,type:str]
sops:
    kms: []
    gcp_kms: []
    azure_kv: []
    lastmodified: '2020-08-25T22:05:10Z'
    mac: ENC[AES256_GCM,data:5db6CLC37zNIzv35OhTkyAr68bIil7+PCNUAyQAh16OqZoVeAxKZLdpe5LHvjmGRImMXPspjs5zyiwWSJhEaCBNSYxrAIJgJrYqpqWyr7jvD2aMxuvKI8VC2t1csnMqKI6Qrp33/5M3EeKnIqJ3vIReXYr8OAzhzmKMDWXmxdkQ=,iv:yX1pMA9XKRjgChckD6fUgkKByOATvpV5Pfy0v66gFpA=,tag:T0mCiZCjc4AqB9RAGDqEAw==,type:str]
    pgp:
    -   created_at: '2020-08-12T17:29:21Z'
        enc: |
            -----BEGIN PGP MESSAGE-----

            hQEMA1gSLZ947okQAQf/bYtv3ObIez55ET8rigjQLoKAdQ8qH4iRnEGs/7pliJ9r
            APuQHq1ggNQthVFkZSJqQmyRjW1r7CwkEOHd2aPiKM3dOGK2vdVBHES4LqWrR4cq
            Oa7VRkUNq1WE/4DZh6NDOSn3vBJnZ8OozDK5hrsl95X1aSNhWH9lKlbFDR8VqxWb
            +zz8h6RK7nEmzduc+l00ONbFGPx6y517QpkPJ0urb/N7XfVDtUN/er/2GGywR9a9
            Wu8KR0lymseyemxf1v9Qw2igbJFfZuQgEp2+83amD4Zc02WGNTGRz8kFJcn9MELV
            Gol91lPJNSzvlglVVwJP47kXPeot9I32FFR3qjwkPdJeAfElVY6zasr75yiOSDgK
            oR787IVYPZMMAr6Z+q7xqMpDrhRX3NEHDOCEATHPxLXVH/HkwRHtEtIfxth87MLg
            ye+HrTuHNSADKGKJRWh3fHuzAY1vfFeGGJFNxQIv7w==
            =B5sa
            -----END PGP MESSAGE-----
        fp: 4C80959A5A0DC7D784CEDE1E1B7F34C12F7B86BE
    unencrypted_suffix: _unencrypted
    version: 3.5.0
```

5. Add the file to your git repo.   
```
git add values-stage-secrets.yaml
```

Commit and push your changes.

# Modify existing secrets

If you have the private key, you can simply edit an existing encrypted file with sops:  

```
sops values-stage-secrets.yaml
```

If you don't have the private key you must delete the existing file and replace it with the new one you encrypted.

