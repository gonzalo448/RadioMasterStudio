# init-project.ps1
# Script para crear archivos base en todas las carpetas del proyecto RadioMasterStudio

$folders = @(
    ".github\workflows",
    "audio-engine",
    "backend",
    "db",
    "frontend",
    "ollama",
    "scripts"
)

foreach ($folder in $folders) {
    $fullPath = Join-Path -Path (Get-Location) -ChildPath $folder
    if (!(Test-Path $fullPath)) {
        New-Item -ItemType Directory -Path $fullPath | Out-Null
    }

    switch -Wildcard ($folder) {
        ".github\workflows" {
            Set-Content "$fullPath\build.yml" "name: Build Workflow`n# Configuración inicial"
            Set-Content "$fullPath\release.yml" "name: Release Workflow`n# Configuración inicial"
        }
        "audio-engine" {
            Set-Content "$fullPath\index.js" "// Audio Engine principal"
        }
        "backend" {
            Set-Content "$fullPath\server.js" "// Backend principal"
            Set-Content "$fullPath\package.json" "{`n  `"name`": `"backend`",`n  `"version`": `"1.0.0`",`n  `"main`": `"server.js`"`n}"
        }
        "db" {
            Set-Content "$fullPath\schema.sql" "-- Definición inicial de la base de datos"
        }
        "frontend" {
            Set-Content "$fullPath\App.jsx" "// Componente raíz de React"
            Set-Content "$fullPath\package.json" "{`n  `"name`": `"frontend`",`n  `"version`": `"1.0.0`",`n  `"main`": `"App.jsx`"`n}"
        }
        "ollama" {
            Set-Content "$fullPath\config.yaml" "# Configuración inicial de Ollama"
        }
        "scripts" {
            Set-Content "$fullPath\setup.ps1" "# Script de setup inicial"
            Set-Content "$fullPath\setup.sh" "#!/bin/bash`necho 'Setup inicial'"
        }
    }
}

Write-Host "✅ Archivos base creados en todas las carpetas."
