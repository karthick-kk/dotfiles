# dotfiles
Personalized urxvt Xresources configs

## Requirements 
* git 
* python
* sudoers
* wget
## Usage

Install from current terminal as user and NOT ROOT user

```
$ wget https://raw.githubusercontent.com/karthick-kk/dotfiles/master/deb_install.sh
$ chmod +x deb_install.sh
$ ./deb_install.sh
```

### Optional

To setup ubuntu default like terminal

```
$ cp /tmp/kkdots/X/ubuntu-term/.Xresources $HOME/
$ xrdb -load ~/.Xresources
```
