function Mock-Them($str) {
    $out = $null
    $str.ToCharArray() | %{$out += if((Get-Random) % 2){$_.ToString().ToUpper()}else{$_.ToString().ToLower()}}
    return $out
}