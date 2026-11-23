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
