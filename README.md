# Role mw-user

Este role maneja los usuarios de mikroways y sus claves públicas de forma
consistente. Para ello, al incluir el role, por defecto se creará una cuenta
mikroways con las claves públicas de todos los integrantes
disponibles en el repositorio [git de claves ssh](https://gitlab.com/mikroways/public/ssh_keys/).

## Requerimientos

Este role depende de los roles GROG declarados en `meta/main.yml`.
`ansible-galaxy` los instala automáticamente al instalar este role.

Para desarrollo local, `uv sync` + molecule se encargan de todo
automáticamente (ver sección [Desarrollo](#desarrollo)).

## Variables

Podemos personalizar el role mediante las siguientes variables que se describen
a continuación:

* **`mw_user_create_one_account_per_user`:** su valor por defecto es `false`. Si es
  true creará una cuenta para cada usuario. Sino solamente creará la cuenta
  `mw_user_name`.
* **`mw_user_name`:** por defecto es el nombre `mikroways`. Esta cuenta siempre
  será creada por este role. Todas las claves públicas de los miembros de
  mikroways seleccionados serán autorizados a usar esta cuenta.
* **`mw_user_url`:** por defecto es `https://mikroways.gitlab.io/public/ssh_keys/_users`. Esta url devuelve un listado de usuarios válidos de mikroways.
* **`mw_user_key_url`:** url template para descargar la clave pública de un
  usuario. El valor por defecto es `https://mikroways.gitlab.io/public/ssh_keys/%user%.pub`. Puede observarse que el valor de `%user%` es dinámico y será reemplazado por el valor de un usuario válido de mikroways.
* **`mw_user_enabled_users`:** lista de usuarios habilitados. Si es vacío, todos
  los usuarios válidos de mikroways (los listados en `mw_user_url`) serán
  considerados. Caso contrario se realizará la intersección de usuarios válidos
  con los usernames dados en esta lista.
* **`mw_user_template`:** diccionario modelo de cómo será creado cada usuario en
  el sistema. El modelo de diccionario depende del role
  [grog.management-user](https://github.com/GROG/ansible-role-management-user)
* **`mw_users_to_remove`:** lista de usuarios que deben ser eliminados. Si un usuario en esta lista fue creado previamente, será eliminado automáticamente del sistema. Además, si las claves públicas de estos usuarios están autorizadas en la cuenta compartida `mw_user_name`, también se eliminarán de la lista `authorized_keys`.

### Configuración para usuarios y administrador de cliente

* **`mw_user_add_client_accounts`:** su valor por defecto es `false`. Si es true, se creará una o más cuentas para el cliente. Si es false, se omite la sección para el cliente.
* **`mw_user_customer_create_one_account_per_user`:** su valor por defecto es `false`. Si es true, se creará una cuenta individual para cada entrada en `mw_user_customer_users`. Si es false, solo se crea el usuario admin compartido.
* **`mw_user_customer_admin_name`:** por defecto es `admin`. Esta cuenta siempre se crea cuando `mw_user_add_client_accounts` es true. Recibe las claves públicas de todos los usuarios en `mw_user_customer_users`.
* **`mw_user_customer_users`:** lista de usuarios del cliente. Cada entrada debe tener `name` (nombre de usuario) y `key` (clave pública SSH). Por defecto es una lista vacía.

  ```yaml
  mw_user_customer_users:
    - name: alice
      key: "ssh-ed25519 AAAA... alice"
    - name: bob
      key: "ssh-ed25519 AAAA... bob"
  ```

* **`mw_user_customer_template`:** diccionario modelo de cómo será creado cada usuario del cliente en el sistema. Puede personalizarse para definir shell, permisos sudo, y otras configuraciones.

## Ejemplo

Agregar este role al `requirements.yml` del proyecto:

```yaml
roles:
  - name: mikroways.mw_user
    src: git@gitlab.com:mikroways/ansible/mw-user.git
    scm: git
    version: "2.0.0"
```

Instalar el role y sus dependencias:

```bash
ansible-galaxy install -r requirements.yml
```

En un playbook:

```yaml
- name: Some useful playbook
  hosts: all
  gather_facts: true
  tasks:
    - import_role:
        name: mikroways.mw_user
      become: true
      tags:
        - user
```

## Desarrollo

Las pruebas usan [molecule](https://molecule.readthedocs.io/) con Docker. Para correrlas localmente:

```bash
uv sync                    # instala las dependencias
uv run molecule converge   # crea los contenedores y aplica el rol
uv run molecule verify     # verifica que el rol hizo lo esperado
uv run molecule destroy    # destruye los contenedores
```

O el ciclo completo:

```bash
uv run molecule test       # dependency + create + converge + verify + destroy
```

## TODO

* [x] Eliminar usuarios que ya no trabajan con nosotros. Pensaba que en el repo
  de nuestras claves, podemos agregar quienes se fueron y han trabajado con
  nosotros. De esta forma el playbook debe eliminar estos usuarios si fueron
  creados previamente
* [x] Mejorar los tests
* [ ] Pinear versión de uv en el Dockerfile en lugar de bajar el script de
  instalación sin versión fija
* [ ] Desacoplar verify.yml de la red: los `lookup('url', ...)` fallan si el
  servidor de claves está caído, aunque el rol haya funcionado correctamente
