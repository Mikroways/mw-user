# Role mw-user

Este role maneja los usuarios de mikroways y sus claves públicas de forma
consistente. Para ello, al incluir el role, por defecto se creará una cuenta
mikroways por defecto con las claves públicas de todos los integrantes
disponibles en el repositorio [git de claves ssh](https://gitlab.com/mikroways/public/ssh_keys/).

## Requerimientos

Este role depende de otros pero deberían instalarse automáticamente con
`ansible-galaxy`.

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
 **`mw_user_enabled_users`:** lista de usuarios habilitados. Si es vacío, todos
los usuarios válidos de mikroways (los listados en `mw_user_url`) serán
considerados. Caso contrario se realizará la intersección de usuarios válidosm
con los usernames dados en esta lista.
* **`mw_user_template`:** diccionario modelo de cómo será creado cada usuarioen
  el sistema. El modelo de diccionario depende del role
[grog.management-user](https://github.com/GROG/ansible-role-management-user)



## Ejemplo

Crear un archivo de requerimientos de galaxy `requirements.yml` con el siguiente
contenido:

```yaml
# from GitLab or other git-based scm
- src: git@gitlab.com:mikroways/ansible/mw-user.git
  scm: git
  version: "1.0.0" 
```
