#set page(paper: "a4", margin: (left: 2cm, right: 1.2cm, top: 2cm, bottom: 2cm))
#set par(justify: true)
#set text(font: "Times New Roman", size: 12pt)

#show raw.where(block: true): it => block(
  fill: luma(240),
  inset: 8pt,
  radius: 5pt,
  width: 100%,
  it
)


// Титульная страница
#align(center)[
  #text(size: 14pt, weight: "bold")[МИНИСТЕРСТВО НАУКИ И ВЫСШЕГО ОБРАЗОВАНИЯ РОССИЙСКОЙ ФЕДЕРАЦИИ]

  Федеральное государственное автономное образовательное учреждение высшего образования

  Санкт-Петербургский национальный исследовательский университет ИТМО

  #v(0.4cm)
  Мегафакультет трансляционных информационных технологий

  #v(0.6cm)
  Факультет информационных технологий и программирования

  #v(0.2cm)
  #text(size: 16pt, weight: "bold")[Отчет по лабораторной работе №5]

  #v(0.3cm)
  По дисциплине "Администрирование Linux"

  #h(4cm)
  #block[
    #text(weight: "bold")[Выполнил студент группы М3303]
    #v(0.1cm)
    #emph[Лукин Даниил Валерьевич]
    #v(0.2cm)
    #text(weight: "bold")[Проверил]
    #v(0.1cm)
    #emph[Гумбатов Владислав Юрьевич]
  ]

  #v(0.5cm)
  #image("img/image1.png", width: 80%)

  Санкт-Петербург

  2026
]

#pagebreak()

= Задание
Создайте текстовый файл, в котором запишете последовательность команд для выполнения каждого из нижеследующих заданий. 
Для команд, имеющих интерактивный интерфейс, опишите последовательность выбора управляющих команд и их параметров. 
Если решение заключается в изменении конфигурационного файла, укажите название файла и вносимые правки. 
Во многих заданиях будет фигурировать *ID* – это последние 2 цифры вашего номера студента в ИСУ.  

=== 1. Квоты на процессор для конкретного пользователя (cgroups v2)  
- Создайте пользователя: `user-ID` (например, `user-72`).  
- Назначьте квоту процессора на основе номера пользователя:  
  - Если имя пользователя заканчивается на *0-30*: 30% CPU.  
  - Если имя пользователя заканчивается на *31-70*: 50% CPU.  
  - Если имя пользователя заканчивается на *71-99*: 70% CPU.  

=== 2. Ограничение памяти для процесса (cgroups)  
- Создайте cgroup для ограничения памяти, потребляемой процессом.  
- Запустите процесс и переместите его в созданную вами группу.  
  - Пример команды: `tail /dev/zero`.  
- Ограничьте потребление памяти следующим образом: `ID*10 + 500 МБ` (например, ID=23 → 730 МБ).  
- Проверьте, что при исчерпании памяти процессом он прерывается ОС.  

=== 3. Ограничение дискового ввода-вывода для сценария резервного копирования (cgroups)  
- Скрипт резервного копирования (`backup.sh`) перегружает дисковую подсистему.  
- Ограничьте его до:  
  - Чтение: `1000 + <ID>*10 IOPS`.  
  - Запись: `500 + <ID>*10 IOPS`.  
- Используйте `cgcreate` для установки ограничений `io.max`.  
- Протестируйте с помощью `fio` или `dd`.  

=== 4. Закрепление к определенному ядру процессора для приложения  
- Настройте с помощью cgroups процесс команды `top` за процессором 0.  
- Используйте `cpuset.cpus` в cgroups.  
- Проверьте с помощью `taskset -p <PID>`. (требуется пакет `sysstat`)  

=== 5. Динамическая корректировка ресурсов (cgroups)  
- Напишите сценарий для мониторинга нагрузки по CPU и динамического изменения `cpu.max` определенного процесса (его идентификатор задается как входной параметр скрипта).  
- Квота ЦП для процесса должна регулироваться в зависимости от общей нагрузки на систему:  
  - Низкая нагрузка (CPU < 20%): 80% CPU.  
  - Высокая нагрузка (CPU > 60%): 30% CPU.  

=== 6. Создание изолированного имени хоста (пространство имен UTS)  
- Запустите оболочку (`shell/bash`) в отдельном namespace, в которой можно изменить имя хоста, не затрагивая хост.  
- Измените имя хоста внутри пространства имен на `isolated-student-<ID>`.  
- Проверьте изоляцию:  
  - `hostname` - Должно отображаться «isolated-student-<ID>».  
  - Проверьте имя хоста (в новом терминале): `hostname` - По-прежнему показывает оригинальное имя хоста.  

=== 7. Изоляция процессов (пространство имен PID)  
- Создайте пространство имен, в котором процессы хоста будут невидимы:  
  - `unshare --pid --fork bash`.  
- Смонтируйте новый каталог `/proc`:  
  - `mount -t proc proc /proc`.  
- Проверьте процессы:  
  - `ps aux` = Показывает только 2-3 процесса (например, `bash`, `ps`).  
- Сравните с хостом (в новом терминале):  
  - `ps aux` = Показывает все процессы хоста.  

=== 8. Изолированная файловая система (пространство имен Mount)  
- Создайте каталог, видимый только в пространстве имен:  
  - `unshare --mount bash`.  
- Создайте приватный каталог:  
  - `mkdir /tmp/private_$(whoami)`.  
- Смонтируйте временную файловую систему:  
  - `mount -t tmpfs tmpfs /tmp/private_$(whoami)`.  
- Проверьте изоляцию:  
  - `df -h | grep private_$(whoami)` = Запишите в отчет результат.  
- Проверка на хосте (в новом терминале):  
  - `df -h | grep private_$(whoami)`.  

=== 9. Отключение доступа к сети (пространство имен Network)  
- Запустите командный интерпретатор `bash` без доступа к сети.  
- Проверьте сетевые интерфейсы:  
  - `ip addr` = Запишите в отчет, что показывает команда.  
- Проверьте подключение:  
  - `ping google.com`.  
- Сравните с хостом (в новом терминале):  
  - `ping google.com`.  

=== 10. Создайте и проанализируйте монтирование OverlayFS  
==== Шаги:  
*a. Первоначальная настройка:*
- Создайте каталоги:  
  ```bash
  mkdir -p ~/overlay_<ID>/{lower,upper,work,merged}
  ```  
- В каталоге `lower` создайте файл с именем `<ID>_original.txt` с содержанием:  
  ```text
  Оригинальный текст из LOWER
  ```  
- Смонтируйте OverlayFS:  
  ```bash
  mount -t overlay overlay -o lowerdir=~/overlay_<ID>/lower,upperdir=~/overlay_<ID>/upper,workdir=~/overlay_<ID>/work ~/overlay_<ID>/merged
  ```  

*b. Имитация неполадки и отладка:*  
- Удалите файл `<ID>_original.txt` из каталога `merged`.  
- Понаблюдайте: Какой файл(ы) появился(ись) в верхнем каталоге? Задокументируйте их имена и содержимое.  
- Измените каталог `merged`, чтобы *восстановить* `<ID>_original.txt`, не размонтируя и не изменяя нижний уровень.  

*c. Разработайте скрипт, который:*  
- Обнаруживает все `whiteout` файлы в верхнем каталоге `upper`.  
- Сравнивает содержимое нижнего и объединенного для выявления несоответствий.  
- Выводит отчет с именем `<ID>_audit.log`.  

*d. Ответьте на вопросы:*  
- Как OverlayFS скрывает файлы из нижнего слоя при удалении в объединенном?  
- Если вы удалите рабочий каталог `work`, сможете ли вы перемонтировать оверлей? Объясните, почему.  
- Что произойдет с объединенным слоем, если верхний каталог будет пуст?  

=== 11.	Оптимизируйте Dockerfile для приведенного ниже приложения app.py
```Python
from flask import Flask
import socket
import os

app = Flask(__name__)

@app.route('/')
def container_info():
    # Get container IP
    hostname = socket.gethostname()
    ip_address = socket.gethostbyname(hostname)
    # Get student name from environment variable
    student_name = os.getenv('STUDENT_NAME', 'Rincewind')
    return f"Container IP: {ip_address} Student: {student_name}"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

*Исходный Dockerfile:*  
```dockerfile
FROM python:latest
COPY . /app
WORKDIR /app
RUN pip install flask
CMD ["python", "app.py"]
```  

*Улучшите Dockerfile с учетом лучших практик:*  
- Используйте меньший базовый образ.  
- Зафиксируйте версию образа.  
- Запуск от имени пользователя, не являющегося root.  
- Используйте кэширование слоев для зависимостей.  
- Добавьте файл `.dockerignore`.  

---

=== 12. Установка платформы публикации WordPress с помощью Docker Compose  
*Задача:*  
Создать `docker-compose.yml` для запуска WordPress и MySQL/MariaDB с сохранением состояния при перезапуске контейнеров.  

*Используйте:*  
- Порт `<ID>+2000` для WordPress (например, ID = 65 → port = 2065).  
- Пароль базы данных: `[ваше_имя]_db_pass`.  
- Том с именем `[ваше_имя]-wp-data` для WordPress.  

#pagebreak()

= Выполнение работы

== Часть 1. Квоты на процессор для конкретного пользователя (cgroups v2)
- Создан пользователь user-31: sudo useradd -m user-31
- Создана cgroup: mkdir /sys/fs/cgroup/user-31
- Установлено ограничение CPU: echo "50000 100000" > /sys/fs/cgroup/user-31/cpu.max
- Назначена квота CPU через systemd: systemctl set-property user-31.slice CPUQuota=50%
Проверка выполнена с помощью утилиты stress. Нагрузка процесса не превышает 50% CPU.

#image("img/lab-5/2026-04-03-083504_hyprshot.png", width: 100%)
#image("img/lab-5/2026-04-03-083626_hyprshot.png", width: 100%)

== Часть 2. Ограничение памяти для процесса (cgroups v2)
- Создана cgroup: mkdir /sys/fs/cgroup/memory_limit_31
- Установлен лимит памяти: echo 849346560 > memory.max
- Запущен процесс: tail /dev/zero &
- Процесс добавлен в cgroup: echo <PID> > cgroup.procs
- Для тестирования использована утилита stress: stress --vm 1 --vm-bytes 900M

При превышении лимита процесс завершён системой (OOM killer).

#image("img/lab-5/2026-04-03-084415_hyprshot.png", width: 100%)
#image("img/lab-5/2026-04-03-084217_hyprshot.png", width: 100%)
#image("img/lab-5/2026-04-03-084244_hyprshot.png", width: 100%)

#pagebreak()

== Часть 3. Ограничение дискового ввода-вывода для сценария резервного копирования (cgroups)
- Определено устройство диска: lsblk → 8:0
- Создана cgroup: mkdir /sys/fs/cgroup/io_limit_31
- Установлены ограничения: echo "8:0 riops=1310 wiops=810" > io.max
- Проверка выполнена с помощью fio.

```sh
#!/bin/bash
sudo cgexec -g io:io_limit_31 fio --name=write_test --filename=testfile --size=1G --bs=4k --rw=write --direct=1 --iodepth=1 --runtime=10 --time_based
sudo cgexec -g io:io_limit_31 fio --name=read_test --filename=testfile --size=1G --bs=4k --rw=read --direct=1 --iodepth=1 --runtime=10 --time_based
```

#image("img/lab-5/2026-04-03-084552_hyprshot.png", width: 100%)
#image("img/lab-5/2026-04-03-090647_hyprshot.png", width: 100%)
#image("img/lab-5/2026-04-03-090558_hyprshot.png", width: 100%)

#pagebreak()

== Часть 4. Закрепление к определенному ядру процессора для приложения
- Создана cgroup: mkdir /sys/fs/cgroup/cpuset_top_31
- Настроены параметры:
  - echo 0 > cpuset.cpus
  - echo 0 > cpuset.mems

#image("img/lab-5/2026-04-03-091344_hyprshot.png", width: 100%)
#image("img/lab-5/2026-04-03-091309_hyprshot.png", width: 100%)

#pagebreak()

== Часть 5. Динамическая корректировка ресурсов (cgroups)
- Создана cgroup: mkdir /sys/fs/cgroup/dynamic_cpu_31
- Разработан скрипт cpu_control.sh для мониторинга нагрузки CPU и изменения cpu.max.
- Логика:
  - CPU < 20% → 80% CPU
  - CPU > 60% → 30% CPU

#image("img/lab-5/2026-04-03-091646_hyprshot.png", width: 100%)
#image("img/lab-5/2026-04-03-092028_hyprshot.png", width: 100%)

```sh
#!/bin/bash
CGROUP="/sys/fs/cgroup/dynamic_cpu_31"
PID=$1
if [ -z "$PID" ]; then
    echo "Usage: $0 <PID>"
    exit 1
fi

echo $PID | sudo tee $CGROUP/cgroup.procs > /dev/null
echo "Monitoring CPU load..."

while true; do
    CPU_LOAD=$(mpstat 1 1 | awk '/Average/ {print 100 - $NF}')
    CPU_LOAD_INT=${CPU_LOAD%.*}
    echo "CPU load: $CPU_LOAD_INT%"
    if [ "$CPU_LOAD_INT" -lt 20 ]; then
        echo "Setting CPU limit to 80%"
        echo "80000 100000" | sudo tee $CGROUP/cpu.max > /dev/null
    elif [ "$CPU_LOAD_INT" -gt 60 ]; then
        echo "Setting CPU limit to 30%"
        echo "30000 100000" | sudo tee $CGROUP/cpu.max > /dev/null
    fi
    sleep 2
done
```

#pagebreak()  

== Часть 6. Создание изолированного имени хоста (пространство имен UTS)
- Создан namespace: unshare --uts --fork bash
- Изменено имя хоста: hostname isolated-student-31
- Проверка: hostname → isolated-student-31
- На хосте: hostname → исходное имя

#image("img/lab-5/2026-04-03-092333_hyprshot.png", width: 100%)

== Часть 7. Изоляция процессов (пространство имен PID)
- Создан namespace: unshare --pid --fork bash
- Смонтирован /proc: mount -t proc proc /proc
- Проверка: ps aux → отображается ограниченное число процессов
- На хосте: ps aux → отображаются все процессы

#image("img/lab-5/2026-04-03-093333_hyprshot.png", width: 100%)

== Часть 8. Изолированная файловая система (пространство имен Mount)
- Создан namespace: unshare --mount bash
- Настроен приватный режим: mount --make-rprivate /
- Создан каталог: ```/tmp/private_$(whoami)```
- Смонтирована ```tmpfs: mount -t tmpfs tmpfs /tmp/private_$(whoami)```
- Проверка внутри: df -h → tmpfs отображается
- Проверка снаружи: df -h → отсутствует

#image("img/lab-5/2026-04-03-093604_hyprshot.png", width: 100%)

== Часть 9. Отключение доступа к сети (пространство имен Network)
- Создан namespace: unshare --net bash
- Проверка интерфейсов: ip addr → доступен только lo
- Проверка сети: ping google.com → сеть недоступна
- На хосте: ping работает

#image("img/lab-5/2026-04-03-093810_hyprshot.png", width: 100%)

#pagebreak()

== Часть 10. Создайте и проанализируйте монтирование OverlayFS
- Создан namespace: unshare --mount bash
- Настроен приватный режим: mount --make-rprivate /
- Создан каталог: ```/tmp/private_$(whoami)```
- Смонтирована ```tmpfs: mount -t tmpfs tmpfs /tmp/private_$(whoami)```
- Проверка внутри: df -h → tmpfs отображается
- Проверка снаружи: df -h → отсутствует

#image("img/lab-5/2026-04-03-095222_hyprshot.png", width: 100%)
#image("img/lab-5/2026-04-03-095533_hyprshot.png", width: 100%)

```sh
#!/bin/bash

BASE=~/overlay_31
UPPER=$BASE/upper
LOWER=$BASE/lower
MERGED=$BASE/merged
LOG=~/overlay_31/31_audit.log

echo "OverlayFS audit report" > $LOG
echo "======================" >> $LOG

echo "Whiteout files:" >> $LOG
find $UPPER -name ".*" >> $LOG

echo "" >> $LOG
echo "Differences between lower and merged:" >> $LOG
diff -r $LOWER $MERGED >> $LOG

echo "Report saved to $LOG"
```

=== Ответы на вопросы
1. *Как OverlayFS скрывает файлы?* OverlayFS использует whiteout-файлы в upper слое. При удалении файла создаётся специальный скрытый файл, который «перекрывает» файл из lower слоя.
2. *Если удалить work?* Нет, перемонтировать нельзя. Каталог work обязателен для работы OverlayFS, так как используется для служебных операций.
3. *Если upper пуст?* Merged слой будет полностью соответствовать lower слою, так как изменений нет.

#pagebreak()

== Часть 11. Оптимизируйте Dockerfile для приведенного ниже приложения app.py
- Использован образ python:3.12-slim.
- Dockerfile оптимизирован:
  - фиксирована версия
  - используется отдельный пользователь
  - кэширование зависимостей - добавлен .dockerignore - Сборка: docker build -t flask-app-31 .
- Запуск: docker run -d -p 5000:5000 -e STUDENT_NAME=Student31 flask-app-31
- Проверка: curl http://localhost:5000

=== Dockerfile
```Dockerfile
FROM python:3.12-slim
WORKDIR /app
RUN useradd -m -r appuser
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
RUN chown -R appuser:appuser /app
USER appuser
EXPOSE 5000
CMD ["python", "app.py"]
```
=== requirements
```txt
flask==3.0.3
```

=== .dockerignore 
```Dockerfile
__pycache__/
*.pyc
*.pyo
*.pyd
venv/
.env
.git/
.gitignore
Dockerfile
docker-compose.yml
```

#image("img/lab-5/2026-04-03-100451_hyprshot.png", width: 100%)
#image("img/lab-5/2026-04-03-105129_hyprshot.png", width: 100%)

#pagebreak()

== Часть 12. Установка платформы публикации WordPress с помощью Docker Compose
- Создан docker-compose.yml.
- Использованы параметры:
  - порт: 2031
  - пароль БД: student_db_pass
  - том: student-wp-data
- Запуск: docker compose up -d
- Проверка: docker ps
- После запуска созданы сети:
  - docker0
  - br-xxxx
- Созданы volumes:
  - student-wp-data
  - db_data_31

#image("img/lab-5/2026-04-03-101934_hyprshot.png")
#image("img/lab-5/2026-04-03-101740_hyprshot.png")
