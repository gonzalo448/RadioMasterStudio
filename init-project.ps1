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

# --- Inicialización de módulos base ---
$modules = @{
    "backend/server.js" = @"
const express = require('express');
const app = express();
const PORT = process.env.PORT || 4000;

app.get('/', (req, res) => {
  res.send('Backend funcionando 🚀');
});

app.listen(PORT, () => {
  console.log(`Servidor backend escuchando en puerto ${PORT}`);
});
"@

    "backend/package.json" = @"
{
  "name": "backend",
  "version": "1.0.0",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.18.2"
  }
}
"@

    "frontend/App.jsx" = @"
import React from 'react';

function App() {
  return (
    <div>
      <h1>Frontend funcionando 🚀</h1>
    </div>
  );
}

export default App;
"@

    "frontend/package.json" = @"
{
  "name": "frontend",
  "version": "1.0.0",
  "main": "App.jsx",
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  }
}
"@

    "audio-engine/index.js" = @"
console.log('Audio Engine inicializado 🎵');
"@

    "ollama/config.yaml" = @"
models:
  - llama3:latest
  - qwen2.5-coder:7b
  - mxbai-embed-large
"@

    "scripts/setup.sh" = @"
#!/bin/bash
echo 'Inicializando proyecto...'
npm install
echo 'Proyecto listo 🚀'
"@

    "scripts/setup.ps1" = @"
Write-Host 'Inicializando proyecto...'
npm install
Write-Host 'Proyecto listo 🚀'
"@
}

foreach ($file in $modules.Keys) {
    $content = $modules[$file]
    $dir = Split-Path $file
    if (!(Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir }
    Set-Content -Path $file -Value $content -Force
    Write-Host "✅ Archivo creado/actualizado: $file"
}

