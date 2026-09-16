@echo off
title Otomasi Git Push Origin Main - Portofolio Anggun
color 0B
cd /d "%~dp0"

echo ======================================================
echo       OTOMASI GIT PUSH KE ORIGIN MAIN
echo       Portofolio Anggun Reni Novitasari
echo ======================================================
echo.

:: 1. Cek apakah Git terpasang
where git >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Git belum terinstall di komputer ini.
    echo Silakan install Git terlebih dahulu dari https://git-scm.com/
    pause
    exit /b
)

:: 2. Cek apakah folder .git sudah ada
if not exist ".git" (
    echo [1/4] Menginisialisasi Git Repository (git init)...
    git init
    git branch -M main
) else (
    echo [1/4] Git Repository sudah siap.
)

:: 3. Cek Konfigurasi Nama dan Email
for /f "tokens=*" %%i in ('git config user.name') do set GIT_NAME=%%i
if "%GIT_NAME%"=="" (
    echo.
    set /p GIT_NAME="Masukkan nama lengkap Anda (default: Anggun Reni Novitasari): "
    if "%GIT_NAME%"=="" set GIT_NAME=Anggun Reni Novitasari
    git config --global user.name "%GIT_NAME%"
)

for /f "tokens=*" %%i in ('git config user.email') do set GIT_EMAIL=%%i
if "%GIT_EMAIL%"=="" (
    echo.
    set /p GIT_EMAIL="Masukkan email GitHub Anda: "
    if not "%GIT_EMAIL%"=="" git config --global user.email "%GIT_EMAIL%"
)

:: 4. Cek Remote 'origin'
git remote get-url origin >nul 2>&1
if errorlevel 1 (
    echo.
    echo Remote 'origin' belum terdaftar!
    echo Contoh URL: https://github.com/username/nama-repository.git
    set /p REPO_URL="Masukkan URL Repository GitHub: "
    if "%REPO_URL%"=="" (
        echo [!] URL GitHub tidak diisi. Push dibatalkan.
        pause
        exit /b
    )
    git remote add origin %REPO_URL%
    echo Remote origin berhasil ditambahkan.
)

:: 5. Git Add
echo.
echo [2/4] Menambahkan semua perubahan file (git add .)...
git add .

:: 6. Git Commit
echo.
set /p COMMIT_MSG="[3/4] Masukkan pesan commit [Tekan Enter untuk 'Update portofolio']: "
if "%COMMIT_MSG%"=="" set COMMIT_MSG=Update portofolio
git commit -m "%COMMIT_MSG%"

:: 7. Pastikan branch main & Git Push
echo.
echo [4/4] Menyelaraskan dengan remote dan mengirim ke GitHub...
git branch -M main
git pull origin main --rebase
git push -u origin main

if %errorlevel% equ 0 (
    echo.
    echo ======================================================
    echo   BERHASIL DIPUSH KE ORIGIN MAIN!
    echo ======================================================
) else (
    echo.
    echo [!] Terjadi kendala saat push.
    echo Pastikan URL repository benar dan Anda memiliki akses push ke GitHub.
)

echo.
pause
