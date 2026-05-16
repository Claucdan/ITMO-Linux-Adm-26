# Билет 16. Пакетная установка ПО: внутреннее устройство пакетов RPM

## PARA

- **Project:** подготовка к экзамену по администрированию Linux.
- **Area:** RPM packages, rpm, dnf/yum, spec-файлы, репозитории.
- **Resources:** `lectures/admlinux_2026_02_06.md`, `docs/Lab3.typ` для сравнения с APT/DPKG.
- **Archive:** связанный материал: [Билет 13](./ticket_13.md), [Билет 14](./ticket_14.md), [Билет 15](./ticket_15.md).

## Zettel

**Главная мысль:** RPM - пакетный формат и низкоуровневая база учета файлов, аналогичная роли dpkg в Debian-мире; зависимости и репозитории обычно обрабатывает более высокий уровень `dnf` или `yum`.

## Развернутый ответ

RPM означает RPM Package Manager. Этот формат используется в Red Hat Enterprise Linux, Fedora, CentOS Stream, AlmaLinux, Rocky Linux, openSUSE и других RPM-based дистрибутивах.

Как и в Debian-мире, есть два уровня:

- `rpm` - низкоуровневая установка, удаление, запросы к базе;
- `dnf`/`yum` - высокоуровневый менеджер с репозиториями и зависимостями.

Примеры:

```bash
sudo rpm -i package.rpm
sudo dnf install package
sudo dnf install ./package.rpm
```

## Задачи RPM-пакета

RPM-пакет должен:

- доставить файлы программы;
- описать имя, версию, релиз, архитектуру;
- указать зависимости;
- указать конфликты и предоставляемые возможности;
- выполнить скрипты установки/удаления;
- зарегистрировать файлы в базе RPM;
- дать возможность проверить целостность.

## Имя RPM-пакета

Типичный файл:

```text
name-version-release.arch.rpm
```

Пример:

```text
nginx-1.24.0-3.fc40.x86_64.rpm
```

Где:

- `name` - имя пакета;
- `version` - версия upstream;
- `release` - релиз сборки в дистрибутиве;
- `arch` - архитектура.

Для исходных пакетов:

```text
.src.rpm
```

## Внутреннее устройство RPM

Современный RPM содержит:

- lead, исторический заголовок для совместимости;
- signature header, подписи и контрольные суммы;
- header, метаданные пакета;
- payload, архив с файлами.

Payload обычно является `cpio`-архивом со сжатием: gzip, xz, zstd и т.д.

Упрощенно:

```text
RPM package
├── signatures
├── metadata header
└── payload: файлы программы
```

## Метаданные RPM

В header хранятся:

- имя пакета;
- версия;
- релиз;
- epoch, если нужен особый порядок версий;
- архитектура;
- summary;
- description;
- license;
- group или category;
- packager/vendor;
- build time;
- список файлов;
- права, владельцы и группы файлов;
- зависимости;
- provides;
- conflicts;
- obsoletes;
- скрипты установки и удаления;
- changelog.

Посмотреть:

```bash
rpm -qip package.rpm
rpm -qlp package.rpm
rpm -q --scripts package
```

## Скрипты RPM

RPM поддерживает scriptlets:

| Скрипт | Когда выполняется |
|---|---|
| `%pre` | перед установкой |
| `%post` | после установки |
| `%preun` | перед удалением |
| `%postun` | после удаления |
| `%pretrans` | перед транзакцией |
| `%posttrans` | после транзакции |

Примеры задач:

- создать пользователя службы;
- обновить кэш;
- перезапустить или перечитать service manager;
- зарегистрировать альтернативы;
- выполнить миграцию.

Скрипты должны быть осторожными: ошибка в них может сломать установку или обновление.

## База RPM

RPM ведет базу установленных пакетов. В современных системах она находится в `/var/lib/rpm` или управляется через backend rpmdb.

Запросы:

```bash
rpm -qa
rpm -qi bash
rpm -ql bash
rpm -qf /usr/bin/bash
rpm -V bash
```

Где:

- `-qa` - все установленные пакеты;
- `-qi` - информация;
- `-ql` - список файлов;
- `-qf` - какому пакету принадлежит файл;
- `-V` - проверка установленных файлов.

## Зависимости

RPM хранит зависимости в метаданных:

- `Requires` - требуется;
- `Provides` - предоставляет возможность;
- `Conflicts` - конфликтует;
- `Obsoletes` - заменяет старый пакет;
- `Recommends`, `Suggests`, `Supplements`, `Enhances` - слабые зависимости в современных системах.

Сам `rpm` может проверить зависимости, но не скачивает их автоматически из репозиториев. Для этого используют `dnf` или `yum`.

```bash
sudo dnf install ./package.rpm
dnf repoquery --requires package
dnf repoquery --whatrequires library
```

## DNF/YUM и репозитории

`dnf` работает с репозиториями, метаданными и транзакциями.

Конфиги:

```text
/etc/yum.repos.d/*.repo
/etc/dnf/dnf.conf
```

Пример `.repo`:

```ini
[myrepo]
name=My Repo
baseurl=file:///srv/repo
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-myrepo
```

Метаданные репозитория обычно создаются:

```bash
createrepo_c /srv/repo
```

Обновить кэш:

```bash
sudo dnf makecache
```

## SPEC-файл

RPM-пакеты обычно собираются из `.spec` файла. Он описывает, как получить, собрать и упаковать программу.

Основные секции:

```spec
Name:           myapp
Version:        1.0
Release:        1%{?dist}
Summary:        Example application
License:        MIT
Source0:        %{name}-%{version}.tar.gz
BuildRequires:  gcc, make
Requires:       glibc

%description
Example application.

%prep
%autosetup

%build
%make_build

%install
%make_install

%files
%license LICENSE
%doc README.md
%{_bindir}/myapp

%changelog
```

Смысл секций:

- `%prep` - подготовить исходники;
- `%build` - собрать;
- `%install` - установить во временный buildroot;
- `%files` - перечислить файлы пакета;
- `%changelog` - история изменений.

Сборка:

```bash
rpmbuild -ba myapp.spec
```

## Установка, обновление, удаление

Низкий уровень:

```bash
sudo rpm -i package.rpm   # install
sudo rpm -U package.rpm   # upgrade/install
sudo rpm -e package       # erase
```

Высокий уровень:

```bash
sudo dnf install package
sudo dnf upgrade package
sudo dnf remove package
sudo dnf history
```

`dnf` предпочтительнее для обычной работы, потому что он решает зависимости и работает с репозиториями.

## Проверка целостности

RPM умеет проверять, изменились ли файлы пакета:

```bash
rpm -V package
```

Он сравнивает размер, права, владельца, группу, checksum, время изменения и другие атрибуты. Это полезно для диагностики повреждений или ручных изменений.

## Сравнение RPM и Debian-пакетов

| Свойство | Debian | RPM |
|---|---|---|
| Низкий уровень | `dpkg` | `rpm` |
| Высокий уровень | `apt` | `dnf`, `yum`, `zypper` |
| Формат | `.deb` | `.rpm` |
| Рецепт сборки | `debian/` | `.spec` |
| База пакетов | `/var/lib/dpkg` | rpmdb |
| Репозиторные метаданные | `Packages`, `Release` | repodata |

## Что сказать на экзамене коротко

RPM-пакет содержит подписи, метаданные и payload с файлами программы. В метаданных хранятся имя, версия, архитектура, зависимости, список файлов и скрипты установки. Низкоуровневая команда `rpm` устанавливает и ведет базу пакетов, но для обычной установки используют `dnf` или `yum`, потому что они работают с репозиториями и зависимостями. Пакеты собираются по `.spec` файлу с секциями подготовки, сборки, установки и списка файлов.

## Code

```bash
# установка и запросы
sudo dnf install nginx
sudo dnf install ./package.rpm
rpm -qa
rpm -qi bash
rpm -ql bash
rpm -qf /usr/bin/bash

# информация о rpm-файле
rpm -qip package.rpm
rpm -qlp package.rpm

# скрипты и проверка
rpm -q --scripts package
rpm -V package

# репозиторий
createrepo_c /srv/repo
sudo dnf makecache

# сборка
rpmbuild -ba myapp.spec
```

## Связи Zettelkasten

- [Билет 13](./ticket_13.md): RPM - один из управляемых способов установки ПО.
- [Билет 14](./ticket_14.md): исходники можно упаковать в RPM через `.spec`.
- [Билет 15](./ticket_15.md): `.deb` и `.rpm` решают одну задачу, но имеют разные инструменты и метаданные.

