# Билет 12. Запуск GNU/Linux по моделям Upstart и systemd

## PARA

- **Project:** подготовка к экзамену по администрированию Linux.
- **Area:** системы инициализации, события, unit-файлы, targets.
- **Resources:** `lectures/admlinux_2026_04_03.md`, `lectures/admlinux_2026_03_06.md`.
- **Archive:** связанный материал: [Билет 8](./ticket_08.md), [Билет 10](./ticket_10.md), [Билет 11](./ticket_11.md).

## Zettel

**Главная мысль:** Upstart и systemd заменяют последовательный SysV-подход более динамичной моделью: Upstart реагирует на события, а systemd описывает систему набором unit-объектов с зависимостями и параллельным запуском.

## Развернутый ответ

После загрузки ядра и переключения на настоящий корень запускается процесс с PID 1. Его задача - довести систему до рабочего состояния. В разные периоды Linux использовал разные модели:

- SysV init - последовательные скрипты и runlevels;
- Upstart - событийная модель;
- systemd - unit-файлы, зависимости, targets и параллельный запуск.

## Upstart

Upstart разрабатывался как замена SysV init, особенно для систем, где устройства и службы появляются динамически. Его главная идея - запускать и останавливать службы по событиям.

Примеры событий:

- старт системы;
- доступность файловой системы;
- появление сетевого интерфейса;
- завершение другой службы;
- переход в runlevel;
- событие от udev.

Вместо жесткого порядка `S20`, `S80` служба описывает, на какие события она реагирует.

Пример конфигурации Upstart:

```conf
description "my app"

start on filesystem and net-device-up IFACE!=lo
stop on runlevel [016]

respawn
exec /usr/bin/myapp
```

Смысл:

- запускать после готовности ФС и сети;
- останавливать при halt, single-user, reboot;
- перезапускать при падении;
- выполнять указанную программу.

Команды Upstart:

```bash
initctl list
sudo initctl start myapp
sudo initctl stop myapp
sudo initctl status myapp
```

Плюсы Upstart:

- лучше SysV для динамических событий;
- есть перезапуск служб;
- зависимости выражаются через события.

Минусы:

- событийную модель сложнее анализировать;
- в современных дистрибутивах почти полностью вытеснен systemd;
- экосистема меньше, чем у systemd.

## systemd

`systemd` - современная система инициализации, часто используемая в Ubuntu, Debian, Fedora, Arch, RHEL и других дистрибутивах.

Главные идеи:

- декларативные unit-файлы;
- явные зависимости;
- параллельный запуск;
- управление службами, сокетами, монтированиями, таймерами;
- журналирование через `journald`;
- cgroups для отслеживания процессов службы;
- targets вместо классических runlevels.

## Unit-файлы

Unit - объект, которым управляет systemd.

Основные типы:

| Тип | Назначение |
|---|---|
| `.service` | служба |
| `.target` | логическая цель состояния системы |
| `.mount` | точка монтирования |
| `.automount` | автомонтирование по обращению |
| `.socket` | сокет для socket activation |
| `.timer` | запуск по расписанию |
| `.path` | реакция на изменение пути |
| `.device` | устройство |
| `.swap` | swap |

Unit-файлы обычно лежат в:

```text
/usr/lib/systemd/system/
/lib/systemd/system/
/etc/systemd/system/
```

Файлы в `/etc/systemd/system` обычно имеют приоритет для локальных изменений.

## Пример `.service`

```ini
[Unit]
Description=My Application
After=network.target

[Service]
Type=simple
User=myappuser
ExecStart=/usr/bin/myapp
Restart=on-failure
StandardOutput=journal

[Install]
WantedBy=multi-user.target
```

Разделы:

- `[Unit]` - описание и зависимости;
- `[Service]` - как запускать процесс;
- `[Install]` - как включать службу в загрузку.

Ключевые директивы:

- `After=` - порядок запуска;
- `Requires=` - жесткая зависимость;
- `Wants=` - мягкая зависимость;
- `ExecStart=` - команда запуска;
- `Restart=` - политика перезапуска;
- `User=` - пользователь службы;
- `WantedBy=` - target, к которому привязывается `enable`.

## Targets вместо runlevels

В systemd runlevels заменены targets.

Примерное соответствие:

| SysV | systemd |
|---|---|
| 0 | `poweroff.target` |
| 1 | `rescue.target` |
| 3 | `multi-user.target` |
| 5 | `graphical.target` |
| 6 | `reboot.target` |

Текущая цель:

```bash
systemctl get-default
```

Установить цель по умолчанию:

```bash
sudo systemctl set-default multi-user.target
sudo systemctl set-default graphical.target
```

Перейти в цель:

```bash
sudo systemctl isolate rescue.target
```

## Загрузка с systemd

После запуска PID 1 systemd:

1. Читает unit-файлы.
2. Строит граф зависимостей.
3. Монтирует файловые системы.
4. Поднимает базовые устройства и сокеты.
5. Запускает службы параллельно, где это возможно.
6. Доводит систему до `multi-user.target` или `graphical.target`.

В отличие от SysV, systemd не просто выполняет набор скриптов по порядку. Он отслеживает состояние каждого unit и его процессов.

## Socket activation

`systemd` может сначала открыть сокет, а службу запустить только при первом подключении. Это ускоряет загрузку и позволяет запускать службы по требованию.

Пример:

- `.socket` слушает порт;
- при подключении активируется `.service`;
- дескриптор сокета передается службе.

## Журналирование

`systemd-journald` собирает логи служб:

```bash
journalctl
journalctl -u ssh
journalctl -b
```

Службе не обязательно писать в отдельный лог: stdout/stderr может попадать в журнал.

## Отличия от SysV init

| Свойство | SysV init | Upstart | systemd |
|---|---|---|---|
| Модель | runlevels и скрипты | события | units и зависимости |
| Запуск | последовательный | событийный | параллельный по графу |
| Конфигурация | shell-скрипты | job-файлы | unit-файлы |
| Перезапуск | ограниченно | есть `respawn` | `Restart=` |
| Логи | внешние механизмы | внешние механизмы | journald |
| Состояние служб | слабое | лучше SysV | отслеживание через cgroups |

## Что сказать на экзамене коротко

Upstart заменил жесткую последовательность SysV событийной моделью: службы стартуют и останавливаются по событиям вроде готовности ФС, сети или перехода runlevel. systemd развивает идею дальше: описывает систему unit-файлами, строит зависимости, запускает службы параллельно, управляет targets, mount, socket, timer и ведет журнал. В современных дистрибутивах systemd чаще всего является PID 1.

## Code

```bash
# PID 1
ps -p 1 -o pid,comm,args

# systemd units
systemctl list-units
systemctl status ssh
sudo systemctl restart ssh
sudo systemctl enable ssh

# targets
systemctl get-default
systemctl list-units --type=target

# логи
journalctl -b
journalctl -u ssh

# Upstart, если система его использует
initctl list
```

## Связи Zettelkasten

- [Билет 10](./ticket_10.md): systemd или Upstart запускаются после ядра как PID 1.
- [Билет 11](./ticket_11.md): Upstart и systemd заменяют SysV init.
- [Билет 8](./ticket_08.md): службы systemd являются управляемыми демонами.

