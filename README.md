## Treinamento HPD

Recebemos uma tarefa para a semana: “Time, preciso que criem um script para fornecer IPs das nossas VLANs para os desenvolvedores.
Vamos dar liberdade a eles, porém iremos começar a fornecer os IPs da VLAN do nosso ambiente de DEV e depois vamos implementando outras VLANs.”

### Alguns pontos importantes:

> Nossa VLAN, se chama vlan_dev, os IPs disponíveis são: 10.1.10.3, 10.1.10.4, 10.1.10.5, 10.1.10.9, 10.1.10.20, 10.1.10.22, 10.1.10.57, 10.1.10.59

> Os IPs disponíveis devem estar armazenados em um arquivo texto;<br>

> Este script deve fornecer um IP que ainda não foi reservado;<br>

> Este script deve controlar os IPs que estão em uso armazenando cada vez que um IP é liberado para uso, em um arquivo texto;<br>

> Você precisa garantir que não aconteça duplicidade de IPs na nossa rede, por isso dos arquivos textos para armazenar os livres e os disponíveis.<br>

> Quando não houver IPs disponíveis, avise o cliente quando executar seu script.<br>

> Use log de auditoria, com a classe Logger enviando as informações para um arquivo de log, com informações do usuário(email) que solicitou e o IP liberado.<br>

**Dicas do que usar: File/open/read/write, if/else, Array/each, def, Logger**

### How to use
> vcmd<br>
> vcmd help<br>
> vcmd help request<br>
> vcmd help include<br>
> vcmd help remove<br>
> vcmd request use ip<br>
> vcmd request vacate ip<br>
> vcmd include vlan ip<br>
> vcmd remove ip<br>
> vcmd list<br>