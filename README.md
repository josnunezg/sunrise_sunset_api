# 🌅 Sunrise Sunset API – Rails 8 App

A Ruby on Rails 8 application built with Ruby 3.2.2, integrating external APIs for sunrise/sunset data and geolocation services.

## 📦 Requirements

- Ruby 3.2.2 (recommended via rbenv or rvm)
- Rails 8
- PostgreSQL 14+
- Docker (optional)

## 📁 Project Setup

### 🧪 Environment Variables

Create a `.env` file in the root directory with the following content:

```env
SUNRISE_SUNSET_API_BASE_URL="https://api.sunrisesunset.io"
FRONTEND_API_KEY=
OPENSTREET_NOMINATIM_API_BASE_URL="https://nominatim.openstreetmap.org"
DATABASE_HOST=
DATABASE_USER=
DATABASE_PASSWORD=
DATABASE_PORT=
```
> 🧠 Use .env to manage environment variables. Required for both local and Docker usage.
> FRONTEND_API_KEY must be a UUID (see below for generation methods).

## 🍏 macOS Setup

1. Install rbenv & Ruby:
```bash
brew install rbenv ruby-build
rbenv install 3.2.2
rbenv global 3.2.2
```
2. Install PostgreSQL:

```bash
brew install postgresql@14
brew services start postgresql@14
```
3. Set Up PostgreSQL:

```bash
createuser -s postgres
createdb postgres
```
4. Generate UUID for FRONTEND_API_KEY:

```bash
uuidgen
```
Paste the UUID into `.env`.

5. Complete .env Setup:

```env
DATABASE_HOST=127.0.0.1
DATABASE_USER=postgres
DATABASE_PASSWORD=postgres
DATABASE_PORT=5432
```
6. Install Dependencies & Prepare DB:

```bash
bundle install
rails db:prepare
```
7. Run the Server:

```bash
rails server
```
Visit `http://localhost:3000.``

## 🐧 Linux Setup
1. Install rbenv & Ruby:

```bash
sudo apt update
sudo apt install -y git curl libssl-dev libreadline-dev zlib1g-dev
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
rbenv install 3.2.2
rbenv global 3.2.2
```
2. Install PostgreSQL:

```bash
sudo apt install postgresql postgresql-contrib libpq-dev
sudo service postgresql start
sudo -u postgres createuser -s postgres
sudo -u postgres createdb postgres
```
3. Generate UUID for FRONTEND_API_KEY:

```bash
uuidgen
```
Paste it into your `.env`.

4. Complete .env Setup:

```env
DATABASE_HOST=127.0.0.1
DATABASE_USER=postgres
DATABASE_PASSWORD=postgres
DATABASE_PORT=5432
```
5. Install Dependencies & Prepare DB:

```bash
bundle install
rails db:prepare
```
6. Run the Server:

```bash
rails server
```
Visit `http://localhost:3000`.

## 🐳 Docker Setup
1. Install Docker & Docker Compose:

- [Docker Installation](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

2. Set Up .env:

```env
SUNRISE_SUNSET_API_BASE_URL="https://api.sunrisesunset.io"
FRONTEND_API_KEY=<your-generated-uuid>
OPENSTREET_NOMINATIM_API_BASE_URL="https://nominatim.openstreetmap.org"
DATABASE_HOST=db
DATABASE_USER=postgres
DATABASE_PASSWORD=postgres
DATABASE_PORT=5432
```
3. Start with Docker Compose:

```bash
docker-compose up --build
```
Access the app via `http://localhost:3001`.

## 🧪 Running Tests
```bash
bundle exec rspec
```
## 🛠️ Troubleshooting
- PostgreSQL Connection Errors: Check `.env` and PostgreSQL service status.
- Missing Gems: Run `bundle install`.
- Docker Logs: Use `docker-compose logs` for diagnostics.
