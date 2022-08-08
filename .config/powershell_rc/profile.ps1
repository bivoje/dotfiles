
#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
(& "D:\anaconda3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | Invoke-Expression
#endregion

# https://jakupsil.tistory.com/47
# powershell에서 `$profile` 입력해서 나온 경로에 이 파일을 넣어준다.
# https://superuser.com/a/1183389
function sshepherd {
	param($num) # https://www.techtarget.com/searchwindowsserver/tip/Understanding-the-parameters-of-Windows-PowerShell-functions
	ssh -i $HOME\.ssh\shepherd_id_rsa bivoje@172.26.49.9$num
}

# https://stackoverflow.com/a/8386259
function get-shepherd {
	param($num, $from, $to)
	scp -i $HOME\.ssh\shepherd_id_rsa bivoje@172.26.49.9$num`:$from $to
}

function put-shepherd {
	param($num, $from, $to)
	scp -i $HOME\.ssh\shepherd_id_rsa $from bivoje@172.26.49.9$num`:$to
}