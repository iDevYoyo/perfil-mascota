# Perfil de Mascota (Tapreview)

Página que se abre al tocar la medalla NFC o escanear su QR: `https://idevyoyo.github.io/perfil-mascota/?id=ID`

## Agregar una mascota

1. Agrega una entrada en `datos.json` con un ID en minúsculas (ej. `zuky`).
2. Sube la foto como `fotos/ID.jpg`.
3. Graba en el chip la URL `https://idevyoyo.github.io/perfil-mascota/?id=ID`.

## Campos de `datos.json`

| Campo | Obligatorio | Ejemplo |
|---|---|---|
| `nombre` | sí | `"Zuky 🐾"` |
| `dueno` | sí | `"Matías"` |
| `telefono` | sí | `"+56912345678"` |
| `mensaje` | no | `"Por favor, extraño a mi familia."` |
| `ciudad` | no | `"Curicó"` |
| `nota` | no | `"Soy amigable."` |
| `whatsapp` | no (usa `telefono` si falta) | `"+56912345678"` |
| `especie`, `raza`, `color`, `edad` | no | `"Perro"`, `"Mestizo"`, `"Café"`, `"3 años"` |
| `alergias`, `medicamentos` | no | `"Pollo"` |
| `veterinaria`, `veterinaria_telefono` | no | `"Clínica X"`, `"+5675..."` |
| `perdido` | no | `true` → muestra el banner rojo "¡ESTOY PERDIDO!" |
| `recompensa` | no (solo se ve si `perdido` es `true`) | `"$30.000"` |
| `foto` | no (por defecto `fotos/ID.jpg`) | URL de la imagen |

Ver la entrada `demo` como ejemplo: `?id=demo`.

> Ojo: `datos.json` es público. Cualquiera puede descargarlo con los datos de todos los dueños.
> Por eso los perfiles se están pasando a Supabase (ver abajo). Cuando estén todos allá, se vacía `datos.json`.

## Supabase (datos privados + el dueño edita su perfil)

- `supabase/schema.sql`: crea la tabla `mascotas`, la seguridad y la función `perfil_publico`. Se pega en **SQL Editor → Run**.
- `config.js`: Project URL y publishable/anon key (públicas por diseño). Nunca la `service_role`/secret key.
- `index.html` busca primero en Supabase y, si no encuentra, en `datos.json`.
- `editar.html`: el dueño entra con su correo (link mágico, sin contraseña), ve **sus** mascotas y puede activar el modo perdido.

**Agregar una mascota nueva:** Supabase → Table Editor → `mascotas` → Insert row. Llena `id` (minúsculas, números o guiones, ej. `zuky-7k2m`), `owner_email` (correo del comprador) y `nombre`. Lo demás lo puede completar el dueño.

**Seguridad:** nadie puede listar la tabla. El público solo ve una mascota si sabe su `id` y nunca ve el correo del dueño. Cada dueño solo ve y edita las suyas, y no puede cambiar el `id`, el correo ni la foto.

**Configuración en Supabase → Authentication → URL Configuration:**
- Site URL: `https://idevyoyo.github.io/perfil-mascota/`
- Redirect URLs: `https://idevyoyo.github.io/perfil-mascota/**`
