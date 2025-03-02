msg 'Setting up hardware clock...'
hwclock --systz --utc --noadjfile || emergency_shell
