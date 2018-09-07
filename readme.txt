SSH login without password
A->B
A:
ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub | ssh root@192.168.1.101 'cat >> /etc/dropbear/authorized_keys'
cat ~/.ssh/id_rsa.pub | ssh root@192.168.1.102 'cat >> /etc/dropbear/authorized_keys'
cat ~/.ssh/id_rsa.pub | ssh root@192.168.1.103 'cat >> /etc/dropbear/authorized_keys'
cat ~/.ssh/id_rsa.pub | ssh root@192.168.1.104 'cat >> /etc/dropbear/authorized_keys'
cat ~/.ssh/id_rsa.pub | ssh root@192.168.1.105 'cat >> /etc/dropbear/authorized_keys'
cat ~/.ssh/id_rsa.pub | ssh root@192.168.1.106 'cat >> /etc/dropbear/authorized_keys'

Get users connected:
ssh root@192.168.1.101 /etc/config/show_wifi_clients.sh
