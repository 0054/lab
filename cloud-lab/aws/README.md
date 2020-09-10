# AWS


## install aws cli

качаем [отсюда](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html) 
затем распаковываем и устанавливаем например так:
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

## autocompletion


ищим где у нас установлен aws_completer `which aws_completer`
и добавляем в ~/.bashrc строку
```
complete -C /usr/local/bin/aws_completer aws
```
применяем настройки `source ~/.bashrc`

