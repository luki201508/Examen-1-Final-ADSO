[Int32]$num1 = Read-Host -Prompt "Ponga el primer número (entre el 1 y 5)"

[Int32]$num2 = Read-Host -Prompt "Ponga el segundo número (entre el 1 y 5)"

for($i=1;$i-lt 6;$i++) {
    [Int32]$n = $num1 * $num2
    Write-Host -NoNewline ", $n"
    $num1 = $num2
    $num2 = $n
}
