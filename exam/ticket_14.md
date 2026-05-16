# Билет 14. Установка пользовательского ПО из исходного кода

## PARA

- **Project:** подготовка к экзамену по администрированию Linux.
- **Area:** исходники, зависимости сборки, `configure`, `make`, установка в `/usr/local`.
- **Resources:** `docs/Lab3.typ`, `Lab-3/Makefile`.
- **Archive:** связанный материал: [Билет 13](./ticket_13.md), [Билет 15](./ticket_15.md), [Билет 16](./ticket_16.md).

## Zettel

**Главная мысль:** установка из исходников дает максимальный контроль над версией и опциями сборки, но администратор сам отвечает за зависимости, пути установки, обновление, удаление и безопасность.

## Развернутый ответ

Исходный код - это текст программы и файлы сборочной системы. Чтобы получить исполняемую программу, его нужно сконфигурировать, скомпилировать, протестировать и установить.

Установка из исходников нужна, когда:

- нужной версии нет в репозитории;
- нужно включить нестандартную опцию;
- нужно применить патч;
- программа отсутствует в пакетах дистрибутива;
- идет разработка или исследование программы;
- нужно собрать под нестандартную архитектуру или окружение.

## Подготовка окружения

Нужны инструменты сборки:

```bash
sudo apt update
sudo apt install build-essential
```

В Fedora/RHEL:

```bash
sudo dnf groupinstall "Development Tools"
```

Типичные зависимости:

- компилятор: `gcc`, `g++`, `clang`;
- `make`, `cmake`, `ninja`, `meson`;
- заголовочные файлы библиотек: пакеты `*-dev` или `*-devel`;
- `pkg-config`;
- autotools: `autoconf`, `automake`, `libtool`;
- Git, tar, gzip, xz.

В Debian/Ubuntu для исходного пакета можно поставить сборочные зависимости:

```bash
sudo apt build-dep package-name
```

## Получение исходников

Варианты:

```bash
wget https://example.org/app-1.0.tar.gz
tar xf app-1.0.tar.gz
cd app-1.0
```

Или из Git:

```bash
git clone https://example.org/app.git
cd app
```

Или исходники Debian-пакета:

```bash
apt source bastet
```

## Чтение документации

Перед сборкой нужно проверить:

```text
README
INSTALL
BUILDING
docs/
```

Там обычно указаны:

- зависимости;
- команды сборки;
- опции;
- поддерживаемые платформы;
- как запускать тесты;
- куда устанавливаются файлы.

## Классическая схема Autotools

Многие Unix-программы используют:

```bash
./configure
make
sudo make install
```

`./configure` проверяет систему:

- компилятор;
- библиотеки;
- заголовки;
- функции ОС;
- пути установки.

Частые опции:

```bash
./configure --prefix=/usr/local
./configure --prefix=/opt/app
./configure --enable-feature
./configure --disable-feature
```

`make` компилирует программу, `make install` копирует файлы в систему.

## CMake

Современная схема:

```bash
cmake -S . -B build -DCMAKE_INSTALL_PREFIX=/usr/local
cmake --build build
ctest --test-dir build
sudo cmake --install build
```

Плюс out-of-source build: каталог исходников остается чище.

## Meson

Еще один современный вариант:

```bash
meson setup build --prefix=/usr/local
meson compile -C build
meson test -C build
sudo meson install -C build
```

## Путь установки

Нельзя без необходимости перезаписывать файлы дистрибутива в `/usr`. Для локальной сборки обычно используют:

```text
/usr/local
/opt/<app>
```

Смысл:

- `/usr` контролируется пакетным менеджером;
- `/usr/local` предназначен для локально установленного ПО;
- `/opt` подходит для отдельных крупных приложений.

Пример:

```bash
./configure --prefix=/usr/local
make
sudo make install
```

## Права доступа

После установки исполняемый файл обычно должен быть доступен всем:

```bash
sudo install -m 755 app /usr/local/bin/app
```

В лабораторной задаче требовалось, чтобы файл в `/usr/local/bin` имел права:

```text
-rwxr-xr-x
```

То есть `755`.

## Проблема удаления

Главная опасность `sudo make install`: пакетный менеджер не знает, какие файлы были установлены.

Возможные решения:

- использовать `make uninstall`, если цель есть;
- устанавливать в отдельный `/opt/app`;
- использовать `DESTDIR` для сборки пакета;
- применять `checkinstall` или создавать `.deb`/`.rpm`;
- вести список файлов установки.

Пример с `DESTDIR`:

```bash
make
make install DESTDIR="$PWD/pkgroot"
```

Файлы попадут во временный корень, из которого можно собрать пакет.

## Сборка Debian-исходников

В Debian-мире исходный пакет можно получить так:

```bash
apt source package-name
sudo apt build-dep package-name
cd package-version
dpkg-buildpackage -us -uc
```

После сборки появятся `.deb` пакеты, которые можно установить:

```bash
sudo apt install ../package_*.deb
```

Так лучше, чем `make install`, потому что результат становится управляемым пакетом.

## Безопасность

Установка из исходников требует доверия к источнику.

Нужно:

- скачивать с официального сайта или репозитория;
- проверять подписи и хеши, если они есть;
- не запускать случайные install-скрипты от root без проверки;
- собирать от обычного пользователя;
- использовать `sudo` только на этапе установки;
- не добавлять небезопасные пути в `PATH`.

## Что сказать на экзамене коротко

Установка из исходного кода включает получение исходников, установку сборочных зависимостей, конфигурацию, компиляцию, тестирование и установку. Классическая схема - `./configure && make && sudo make install`, современные варианты - CMake и Meson. Лучше устанавливать в `/usr/local` или `/opt`, потому что `/usr` контролируется пакетным менеджером. Главные минусы - сложное удаление, ручное обновление и ответственность администратора за зависимости и безопасность.

## Code

```bash
# зависимости сборки Debian/Ubuntu
sudo apt update
sudo apt install build-essential pkg-config
sudo apt build-dep bastet

# исходники пакета
apt source bastet

# Autotools
./configure --prefix=/usr/local
make -j"$(nproc)"
make check
sudo make install

# CMake
cmake -S . -B build -DCMAKE_INSTALL_PREFIX=/usr/local
cmake --build build
ctest --test-dir build
sudo cmake --install build

# установка файла с правами 755
sudo install -m 755 app /usr/local/bin/app
```

## Связи Zettelkasten

- [Билет 13](./ticket_13.md): исходники - один из способов установки ПО.
- [Билет 15](./ticket_15.md): сборку лучше превращать в `.deb`, если система Debian-based.
- [Билет 16](./ticket_16.md): для RPM-based систем сборку лучше оформлять в RPM.

