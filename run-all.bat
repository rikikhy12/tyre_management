@echo off
setlocal enabledelayedexpansion

title Tyre Management - Docker Compose Runner

echo ===============================================================================
echo            TYRE MANAGEMENT SYSTEM - STARTING ALL SERVICES
echo ===============================================================================
echo.

:: 1. Periksa apakah Docker engine sedang aktif
echo [1/3] Memeriksa status Docker engine...
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Docker tidak terdeteksi atau service Docker belum berjalan!
    echo         Silakan pastikan Docker Desktop sudah aktif lalu jalankan script ini kembali.
    echo.
    pause
    exit /b 1
)
echo [OK] Docker engine terdeteksi dan aktif.
echo.

:: 2. Menjalankan Docker Compose Up Build
echo [2/3] Memulai proses Build dan Deploy seluruh Container...
echo       - Service 1: PostgreSQL Database (Port 25432 / 5432)
echo       - Service 2: cms-backend Java Spring Boot (Port 8081)
echo       - Service 3: be-hexagonal NestJS Management-Tyre (Port 8082)
echo       - Service 4: cms-frontend Vue.js Web Application (Port 8080)
echo.

docker compose up --build -d
if %errorlevel% neq 0 (
    echo.
    echo [INFO] Perintah 'docker compose' gagal, mencoba fallback 'docker-compose'...
    docker-compose up --build -d
    if !errorlevel! neq 0 (
        echo.
        echo [ERROR] Terjadi kesalahan saat menjalankan docker compose!
        echo         Silakan periksa pesan error di atas.
        echo.
        pause
        exit /b !errorlevel!
    )
)

echo.
echo [3/3] Seluruh service berhasil dibangun dan berjalan di background!
echo.
echo ===============================================================================
echo                      RINGKASAN URL AKSES DAN ALOKASI PORT
echo ===============================================================================
echo.
echo  [DATABASE] PostgreSQL
echo   - Host Port       : localhost:25432 (dan localhost:5432)
echo   - Container Port  : 5432
echo   - Database Name   : dev_cms
echo   - Username        : dev_cms
echo   - Password        : Cslg5NxEecL36eV4
echo.
echo  [BACKEND 1] CMS Backend (Java Spring Boot)
echo   - Base URL        : http://localhost:8081/cms
echo   - Port            : 8081 (Host:Container = 8081:8081)
echo   - Login Auth      : POST http://localhost:8081/cms/grant/isafe
echo.
echo  [BACKEND 2] BE Hexagonal (NestJS - Management Tyre)
echo   - Base URL        : http://localhost:8082
echo   - Port            : 8082 (Host:Container = 8082:8082)
echo   - Swagger Docs    : http://localhost:8082/swagger-ui
echo   - Health Check    : http://localhost:8082/management-tyre/health
echo.
echo  [FRONTEND] CMS Frontend (Vue.js Application)
echo   - Web URL         : http://localhost:8080
echo   - Port            : 8080 (Host:Container = 8080:8080)
echo.
echo ===============================================================================
echo  TIPS DAN PERINTAH BERMANFAAT:
echo   - Pantau Log Realtime : docker compose logs -f
echo   - Pantau Log Tertentu : docker compose logs -f cms-backend
echo   - Cek Status Service  : docker compose ps
echo   - Hentikan Service    : docker compose down
echo ===============================================================================
echo.
pause
