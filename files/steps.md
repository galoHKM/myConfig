# Steps to Build an API REST with Symfony

## Setup Database User

1. **Create a User for the Database**:
   ```bash
   sudo -i -u postgres
   psql
   ```
   ```sql
   CREATE USER my_user WITH PASSWORD 'password';
   ALTER USER my_user CREATEDB;
   ```

## Create Symfony Project

2. **Create the Symfony Project and Install Core Bundles**:
   - Start with the Symfony skeleton:
   ```bash
   composer create-project symfony/skeleton app_name
   cd app_name
   ```
   - Install Doctrine related components:
   ```bash
   composer require symfony/orm-pack
   composer require --dev symfony/maker-bundle
   ```

3. **Modify `.env` to Use PostgreSQL**:
   - Edit the `.env` file to connect to PostgreSQL:
   ```bash
   DATABASE_URL="postgresql://my_user:password@127.0.0.1:5432/app?serverVersion=16&charset=utf8"
   ```

## Add API and Security Components

4. **Install API Platform**:
   - Install API Platform to handle REST API features:
   ```bash
   composer require api
   ```

5. **Install JWT Authentication**:
   - Install Lexik JWT Authentication Bundle for securing your API:
   ```bash
   composer require lexik/jwt-authentication-bundle
   ```

6. **Generate JWT Keys**:
   - Generate a pair of keys for signing tokens:
   ```bash
   mkdir -p config/jwt
   openssl genrsa -out config/jwt/private.pem 4096
   openssl rsa -pubout -in config/jwt/private.pem -out config/jwt/public.pem
   ```

7. **Configure JWT in `config/packages/lexik_jwt_authentication.yaml`**:
   ```yaml
   lexik_jwt_authentication:
       secret_key: '%kernel.project_dir%/config/jwt/private.pem'
       public_key: '%kernel.project_dir%/config/jwt/public.pem'
       pass_phrase: '' # Update this with your passphrase if needed
       token_ttl: 3600
   ```

8. **Update Security Configuration in `config/packages/security.yaml`**:
   - Use JWT for authentication and set up your firewalls:
   ```yaml
   security:
       password_hashers:
           Symfony\Component\Security\Core\User\PasswordAuthenticatedUserInterface: 'auto'
       providers:
           app_user_provider:
               entity:
                   class: App\Entity\User
                   property: email
       firewalls:
           dev:
               pattern: ^/(_(profiler|wdt)|css|images|js)/
               security: false
           api:
               pattern: ^/api/
               stateless: true
               jwt: ~
       access_control:
           - { path: ^/api/register, roles: IS_AUTHENTICATED_ANONYMOUSLY }
           - { path: ^/api/, roles: IS_AUTHENTICATED_FULLY }
   ```

## Create the User Model and API

9. **Create User Entity and Migration**:
   - Use the maker bundle to generate the User entity:
   ```bash
   php bin/console make:user
   php bin/console make:migration
   php bin/console doctrine:migrations:migrate
   ```

10. **Create API Login Controller**:
    - Generate a controller for handling login that returns a JWT token:
    ```bash
    php bin/console make:controller --no-template ApiLogin
    ```

11. **Create Additional Endpoints**:
    - Use API Platform annotations or attributes in your entities to expose endpoints.

12. **Clear Cache and Run Server**:
    - Clear cache to apply configurations:
    ```bash
    php bin/console cache:clear
    ```
    - Start the Symfony server:
    ```bash
    symfony server:start
    ```

### To read Later
Using JWT on apiPlatform [Api platform JWT](https://api-platform.com/docs/symfony/jwt/)
Api platform [API Platform Documentation](https://api-platform.com/docs/) 
Symfony auth JWT login [Authentication with JWT](https://symfony.com/bundles/LexikJWTAuthenticationBundle/current/index.html)
Symfony security [Security](https://symfony.com/doc/7.3/security.html#json-login)
Doctrine ORM [Doctrine orm](https://symfony.com/doc/current/doctrine.html) 
Serializer [Symfony Serializer Component](https://symfony.com/doc/current/components/serializer.html)
Error Handling [Symfony Error Handling](https://symfony.com/doc/current/controller/error_pages.html)
Testing [Testing your Symfony Application](https://symfony.com/doc/current/testing.html)
Routing [Routing](https://symfony.com/doc/current/routing.html)
