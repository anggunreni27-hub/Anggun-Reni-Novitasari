' ==========================================================
' Auto Git Push origin main - Portofolio Anggun Reni Novitasari
' SMK Negeri Tembarak (RPL)
' File: git-push.vbs
' ==========================================================

Option Explicit

Dim fso, shell, currentDir, commitMsg, repoUrl, gitDir, exec, output

Set fso = CreateObject("Scripting.FileSystemObject")
Set shell = CreateObject("WScript.Shell")

currentDir = fso.GetParentFolderName(WScript.ScriptFullName)
shell.CurrentDirectory = currentDir

' 1. Cek / Inisialisasi git repository jika belum ada
gitDir = currentDir & "\.git"
If Not fso.FolderExists(gitDir) Then
    Dim initResp
    initResp = MsgBox("Folder ini belum diinisialisasi sebagai Git Repository." & vbCrLf & _
                      "Apakah Anda ingin menginisialisasi sekarang (git init)?", vbYesNo + vbQuestion, "Setup Git Repository")
    If initResp = vbYes Then
        shell.Run "cmd.exe /c git init && git branch -M main", 0, True
    Else
        MsgBox "Proses dibatalkan.", vbInformation, "Batal"
        WScript.Quit
    End If
End If

' 2. Cek apakah user.name & user.email sudah diatur
Dim userName, userEmail
On Error Resume Next
Set exec = shell.Exec("git config user.name")
Do While exec.Status = 0
    WScript.Sleep 50
Loop
userName = Trim(exec.StdOut.ReadAll)

If userName = "" Then
    userName = InputBox("Nama pengguna Git belum diatur." & vbCrLf & vbCrLf & _
                        "Masukkan nama lengkap Anda:", "Konfigurasi Git Name", "Anggun Reni Novitasari")
    If Trim(userName) <> "" Then
        shell.Run "cmd.exe /c git config --global user.name """ & userName & """", 0, True
    End If
End If

Set exec = shell.Exec("git config user.email")
Do While exec.Status = 0
    WScript.Sleep 50
Loop
userEmail = Trim(exec.StdOut.ReadAll)

If userEmail = "" Then
    userEmail = InputBox("Email Git belum diatur." & vbCrLf & vbCrLf & _
                         "Masukkan email akun GitHub Anda:", "Konfigurasi Git Email", "")
    If Trim(userEmail) <> "" Then
        shell.Run "cmd.exe /c git config --global user.email """ & userEmail & """", 0, True
    End If
End If

' 3. Cek apakah remote 'origin' sudah ada
Dim hasOrigin
hasOrigin = False
Set exec = shell.Exec("git remote get-url origin")
Do While exec.Status = 0
    WScript.Sleep 50
Loop
output = Trim(exec.StdOut.ReadAll)
If InStr(output, "http") > 0 Or InStr(output, "git@") > 0 Then
    hasOrigin = True
End If
On Error GoTo 0

If Not hasOrigin Then
    repoUrl = InputBox("Remote 'origin' belum terdaftar." & vbCrLf & vbCrLf & _
                       "Masukkan URL repository GitHub Anda:" & vbCrLf & _
                       "(Contoh: https://github.com/username/portofolio.git)", "Masukkan URL GitHub")
    If Trim(repoUrl) = "" Then
        MsgBox "URL GitHub tidak diisi. Push dibatalkan.", vbExclamation, "Dibatalkan"
        WScript.Quit
    Else
        shell.Run "cmd.exe /c git remote add origin " & Trim(repoUrl), 0, True
    End If
End If

' 4. Minta pesan commit
Dim defaultMsg
defaultMsg = "Update portofolio " & Year(Now) & "-" & Right("0" & Month(Now), 2) & "-" & Right("0" & Day(Now), 2)

commitMsg = InputBox("Masukkan pesan commit untuk perubahan ini:" & vbCrLf & _
                     "(Klik OK untuk lanjut, Cancel untuk keluar)", _
                     "Git Commit Message", defaultMsg)

If Trim(commitMsg) = "" Then
    Dim cancelResp
    cancelResp = MsgBox("Pesan commit kosong. Ingin gunakan pesan default: '" & defaultMsg & "'?", vbYesNo + vbQuestion, "Konfirmasi Commit")
    If cancelResp = vbYes Then
        commitMsg = defaultMsg
    Else
        WScript.Quit
    End If
End If

' 5. Jalankan proses Git di jendela Command Prompt
' Menggunakan cmd.exe /k agar jendela tetap terbuka dan hasil push dapat dilihat
Dim finalCmd
finalCmd = "cmd.exe /k ""color 0B && " & _
           "echo ====================================================== && " & _
           "echo      OTOMASI GIT PUSH KE ORIGIN MAIN                 && " & _
           "echo      Portofolio Anggun Reni Novitasari               && " & _
           "echo ====================================================== && echo. && " & _
           "echo [1/4] Menambahkan semua perubahan (git add .)... && git add . && echo. && " & _
           "echo [2/4] Melakukan commit: """ & commitMsg & """... && git commit -m """ & commitMsg & """ && echo. && " & _
           "echo [3/4] Memastikan branch utama adalah 'main'... && git branch -M main && echo. && " & _
           "echo [4/4] Menyelaraskan & Mengirim ke GitHub (git pull rebase & push)... && git pull origin main --rebase && git push -u origin main && echo. && " & _
           "echo ====================================================== && " & _
           "echo   PROSES SELESAI! Jendela ini dapat ditutup.          && " & _
           "echo ======================================================"""

shell.Run finalCmd, 1, False
