
taskkill /f /im outlook.exe
echo 关闭outlook

start  /min "" "C:\Program Files\Microsoft Office\root\Office16\OUTLOOK.EXE"
echo 运行outlook


taskkill /f /im memreduct.exe
echo 关闭memreduct

start  /min "" "D:\Program Files\Mem Reduct\memreduct.exe"
echo 运行memreduct

taskkill /f /im  hsvaluate.exe

timeout 3
