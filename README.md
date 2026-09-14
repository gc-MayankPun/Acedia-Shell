# Matugen

Matugen generates dynamic colors from your current wallpaper and applies them to different applications.

## Structure

```text
~/.config/matugen/
├── config.toml
└── templates/
    └── ...
```

> The `.rasi` files are **templates**, while `config.toml` tells Matugen how and where to generate the output.

## Installation

Create the Matugen configuration directory:

```bash
mkdir -p ~/.config/matugen
```

### 1. `config.toml`

Place the Matugen configuration file here:

```text
~/.config/matugen/config.toml
```

Example:

```text
~/.config/matugen/
└── config.toml
```

Matugen automatically looks for its configuration here.

---

### 2. Rofi `.rasi` templates

Place your Rofi templates inside:

```text
~/.config/matugen/templates/
```

For example:

```text
~/.config/matugen/
├── config.toml
└── templates/
    ├── config.rasi
    └── clipboard.rasi
```

The `.rasi` files are templates that Matugen uses when generating your Rofi theme.

## Configuring the Rofi template

Your `config.toml` should reference the Rofi template.

For example:

```toml
[templates.rofi]
input_path = '~/.config/matugen/templates/config.rasi'
output_path = '~/.config/rofi/themes/matugen.rasi'
```

Then Matugen generates:

```text
~/.config/rofi/themes/matugen.rasi
```

Do **not** manually edit the generated `.rasi` file because Matugen will overwrite it the next time the theme is generated.

## Recommended structure

A complete setup could look like:

```text
~/.config/
├── matugen/
│   ├── config.toml
│   └── templates/
│       ├── rofi.rasi
│       └── clipboard.rasi
│
└── rofi/
    ├── config.rasi
    └── themes/
        └── matugen.rasi
```

### Templates vs generated files

| File               | Location                       | Purpose               |
| ------------------ | ------------------------------ | --------------------- |
| `config.toml`      | `~/.config/matugen/`           | Matugen configuration |
| `*.rasi` template  | `~/.config/matugen/templates/` | Source template       |
| Generated `*.rasi` | `~/.config/rofi/themes/`       | Actual Rofi theme     |

## Generating the theme

Run:

```bash
matugen image ~/path/to/wallpaper.jpg
```

Matugen will generate the configured files from the templates.

## Important

Keep your **source templates** inside Matugen:

```text
~/.config/matugen/templates/
```

Keep **generated application files** inside the application's configuration directory:

```text
~/.config/rofi/
```

This keeps the setup clean:

```text
Matugen
   │
   ├── config.toml
   │
   └── templates
          │
          ▼
       generated
          │
          ▼
      Rofi config
```

If you are putting this setup in a dotfiles repository, commit the Matugen templates and `config.toml`, but treat generated files as generated output unless you specifically want to version them.
