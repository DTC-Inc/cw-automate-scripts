function GenerateRandomPassword {
    $length = 12 # Change this to adjust the length of the generated password
    $characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-=_+[]{}|;':""<>,.?/\`~"
    $random = New-Object System.Random
    $password = ""
    
    for ($i = 0; $i -lt $length; $i++) {
        $index = $random.Next(0, $characters.Length)
        $password += $characters[$index]
    }
    
    return $password
}
