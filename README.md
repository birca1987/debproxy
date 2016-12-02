docker-acestream
=========================

Debian based docker image for aceproxy.


Рекомендованные опции запуска AceStream

acestreamengine --client-console --core-sandbox-max-peers 30 --live-buffer 500 --upload-limit 1000 --live-cache-type memory

http://wiki.acestream.org/wiki/index.php/Streaming#.D0.9A.D0.BE.D0.BC.D0.B0.D0.BD.D0.B4.D0.B0_acestreamengine

Оптимизизация распределения трафика

Начиная с версии 3.0.5 узлы поддержки умеют автоматически находить пиров с хорошей скоростью отдачи и подсоединять их к себе. Данный алгоритм позволяет оптимизировать распределение трафика. Во время подключения таких пиров общее кол-во подсоединенных пиров может превысить значение --max-peers. Максимальное кол-во пиров сверх значения --max-peers задается опцией --core-sandbox-max-peers (по умолчанию 5). Если задать --core-sandbox-max-peers равным нулю, то алгоритм оптимизации распределения трафика будет отключен, поэтому делать это крайне не рекомендуется. 

Новые параметры для настройки кеша

    --live-cache-type (string) - тип кеша: disk - хранить кеш на диске в папке, указанной параметром --cache-dir, memory - хранить кеш в оперативной памяти (по умолчанию: disk)
    --live-cache-size (integer) - максимальный размер кеша в байтах (по умолчанию: 209715200 байт (200 Мб)) 


