# Билет 15. Пакетная установка ПО: внутреннее устройство пакетов Debian

## PARA

- **Project:** подготовка к экзамену по администрированию Linux.
- **Area:** Debian packages, APT, DPKG, репозитории.
- **Resources:** `docs/Lab3.typ`, `Lab-3/Makefile`.
- **Archive:** связанный материал: [Билет 13](./ticket_13.md), [Билет 14](./ticket_14.md), [Билет 16](./ticket_16.md).

## Zettel

**Главная мысль:** `.deb` - архив с данными программы и управляющими метаданными; `dpkg` устанавливает отдельные пакеты, а APT строит над ним уровень репозиториев, зависимостей, версий и обновлений.

## Развернутый ответ

Debian-пакет - основной формат установки ПО в Debian, Ubuntu и производных дистрибутивах. Файл имеет расширение:

```text
.deb
```

Низкоуровневый инструмент - `dpkg`. Высокоуровневый стек - APT: `apt`, `apt-get`, `apt-cache` и связанные утилиты.

## Уровни управления

### `dpkg`

`dpkg` работает с локальными `.deb` файлами и базой установленных пакетов:

```bash
sudo dpkg -i package.deb
sudo dpkg -r package
dpkg-query -l
dpkg -L package
dpkg -S /path/to/file
```

Он не является полноценным решателем зависимостей. Если зависимости не установлены, `dpkg -i` может оставить пакет в не полностью настроенном состоянии.

### APT

APT работает с репозиториями, индексами и зависимостями:

```bash
sudo apt update
sudo apt install package
sudo apt remove package
sudo apt upgrade
apt show package
apt-cache depends package
apt-cache rdepends package
apt list -a package
```

APT загружает пакеты и вызывает `dpkg` для фактической установки.

## Устройство `.deb`

Формально `.deb` - архив `ar`, внутри которого обычно находятся:

```text
debian-binary
control.tar.xz
data.tar.xz
```

Возможны другие сжатия: `.gz`, `.zst`, `.bz2`.

Команда просмотра:

```bash
ar t package.deb
```

### `debian-binary`

Текстовый файл с версией формата, обычно:

```text
2.0
```

### `control.tar.*`

Архив управляющей информации. В нем находятся метаданные и служебные скрипты.

Главный файл:

```text
control
```

Типичные поля:

| Поле | Смысл |
|---|---|
| `Package` | имя пакета |
| `Version` | версия |
| `Architecture` | архитектура |
| `Maintainer` | сопровождающий |
| `Depends` | зависимости |
| `Pre-Depends` | зависимости, нужные до распаковки/настройки |
| `Recommends` | рекомендуемые пакеты |
| `Suggests` | необязательные полезные пакеты |
| `Conflicts` | конфликтующие пакеты |
| `Replaces` | заменяемые файлы/пакеты |
| `Provides` | виртуальный пакет |
| `Description` | описание |

Служебные maintainer scripts:

| Скрипт | Когда выполняется |
|---|---|
| `preinst` | перед распаковкой |
| `postinst` | после распаковки и настройки |
| `prerm` | перед удалением |
| `postrm` | после удаления |

Также могут быть:

- `conffiles` - список конфигурационных файлов;
- `md5sums` - контрольные суммы;
- `triggers` - триггеры;
- `templates` - шаблоны debconf.

### `data.tar.*`

Архив файлов, которые будут распакованы в корневую файловую систему:

```text
/usr/bin/app
/usr/share/doc/app/
/lib/systemd/system/app.service
/etc/app.conf
```

При установке `dpkg` распаковывает эти файлы в `/`.

## Извлечение и пересборка пакета

Из лабораторной работы:

```bash
apt download nano
mkdir -p nano-rebuild
cd nano-rebuild
dpkg-deb -x ../nano_*.deb temp
dpkg-deb -e ../nano_*.deb temp/DEBIAN
```

Где:

- `-x` извлекает data-часть;
- `-e` извлекает control-часть в `DEBIAN`.

После изменения можно собрать пакет:

```bash
dpkg-deb -b temp newnano.deb
sudo dpkg -i newnano.deb
```

Пример добавления команды:

```bash
ln -s nano temp/usr/bin/newnano
```

## Состояния пакетов

`dpkg` хранит базу пакетов в:

```text
/var/lib/dpkg/
```

Главный файл:

```text
/var/lib/dpkg/status
```

Состояния могут включать:

- not-installed;
- config-files;
- unpacked;
- half-configured;
- installed;
- triggers-pending.

Список установленных пакетов:

```bash
dpkg-query -l
```

Файлы пакета:

```bash
dpkg -L package
```

Какому пакету принадлежит файл:

```bash
dpkg -S /usr/bin/nano
```

## APT-репозиторий

APT использует репозитории. Источники описаны в:

```text
/etc/apt/sources.list
/etc/apt/sources.list.d/*.list
/etc/apt/sources.list.d/*.sources
```

Индексы репозитория:

| Файл | Назначение |
|---|---|
| `Packages` | список бинарных пакетов и метаданные |
| `Sources` | список исходных пакетов |
| `Release` | описание репозитория |
| `Release.gpg` | подпись `Release` |
| `InRelease` | `Release` вместе с подписью |
| `Translation-*` | локализация описаний |

Из лабораторной:

```bash
apt-ftparchive packages . > Packages
apt-ftparchive release . > Release
```

Пример `Release`:

```text
Origin: My Local Repo
Label: My Local Repo
Suite: stable
Version: 1.0
Codename: myrepo
Architectures: amd64
Components: main
Description: My local APT repository
```

После добавления репозитория:

```bash
sudo apt update
apt-cache policy
apt list -a htop
```

## Зависимости

APT умеет анализировать зависимости:

```bash
apt-cache depends gcc
apt-cache rdepends libgpm2
```

Типы связей:

- `Depends` - нужно для работы;
- `Pre-Depends` - нужно еще раньше, до настройки пакета;
- `Recommends` - почти всегда полезно;
- `Suggests` - возможно полезно;
- `Conflicts` - нельзя одновременно;
- `Breaks` - ломает старые версии;
- `Provides` - пакет реализует виртуальную возможность.

## Что сказать на экзамене коротко

Debian-пакет `.deb` состоит из `debian-binary`, управляющего архива `control.tar.*` и архива файлов `data.tar.*`. В control-части лежат метаданные, зависимости и maintainer scripts, а data-часть распаковывается в корневую ФС. `dpkg` устанавливает локальные пакеты и ведет базу `/var/lib/dpkg`, а APT работает с репозиториями, индексами `Packages`/`Release`, версиями и зависимостями.

## Code

```bash
# информация и зависимости
apt show build-essential
apt-cache depends gcc
apt-cache rdepends libgpm2
dpkg-query -l

# скачать и разобрать пакет
apt download nano
ar t nano_*.deb
dpkg-deb -x nano_*.deb temp
dpkg-deb -e nano_*.deb temp/DEBIAN

# собрать и установить
dpkg-deb -b temp newnano.deb
sudo dpkg -i newnano.deb

# локальный репозиторий
apt-ftparchive packages . > Packages
apt-ftparchive release . > Release
sudo apt update
```

## Связи Zettelkasten

- [Билет 13](./ticket_13.md): `.deb` реализует управляемую установку ПО.
- [Билет 14](./ticket_14.md): исходники можно собрать в `.deb` вместо `make install`.
- [Билет 16](./ticket_16.md): RPM решает похожую задачу в другой пакетной экосистеме.

