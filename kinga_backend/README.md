# KinGa Backend

## Django

- Start a new Django project
    ```
    django-admin startproject <name>
    ```
- Start a new Django app:
    ```
    python manage.py startapp <name> 
    ```
- Database migration:
  ```
  python manage.py makemigrations <name>
  python manage.py migrate
  ```
  
## gRPC
- Generate Proto Buffer (for Python):
    ```
    python -m grpc_tools.protoc --proto_path=./ --python_out=./ --grpc_python_out=./ ./backend.proto
    ```
- Generate Proto Buffer (for Dart):
    - First, follow the steps described here to install the Protoc Plugin: https://pub.dev/packages/protoc_plugin
    ```
    protoc --dart_out="grpc:./lib/generated/" backend.proto
    ```
- Run Development Server:
    ```
    python manage.py grpcrunserver --dev
    ```

## Database
- Configuration in settings.py