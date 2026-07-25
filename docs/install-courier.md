# My Couriers

## 1. Prepare the Repository

```sh
git clone https://github.com/shouryadixitisverycool/iiith-glance-widgets.git
cd iiith-glance-widgets
cp .env.example .env
cp vpn.env.example vpn.env
cp proxy.env.example proxy.env
```

The default shared network is `glance_default`. Check the network used by Glance:

```sh
docker inspect glance --format '{{json .NetworkSettings.Networks}}'
```

If it differs, set `GLANCE_NETWORK` in `.env`.

## 2. Prepare the VPN

Download the appropriate profile for your system from [vpn.iiit.ac.in](https://vpn.iiit.ac.in/) and run:

```sh
chmod +x prepare-vpn.sh
./prepare-vpn.sh /path/to/profile.ovpn
```

Add your full IIITH email and LDAP password to `vpn.env`:

```env
OPENVPN_USER=your-full-iiith-email
OPENVPN_PASSWORD=your-iiith-password
```

## 3. Add the Courier Token

The courier portal doesn't have an official API, so this uses its browser token.
Sign in to the [Courier Portal](https://courier.iiit.ac.in/), go to "Registered Users" and use CAS to login. Then open up devtools, head to storage -> local storage where you'll find the `token`. Copy and set that in `proxy.env`:

```env
COURIER_TOKEN=your-courier-portal-token
```

The portal may expire this token. Repeat this step when the widget reports that the login expired.

Protect the credentials and generated profile:

```sh
chmod 600 vpn.env proxy.env iiith.ovpn
```

## 4. Start the Sidecar

```sh
docker compose up -d vpn proxy
docker compose ps
```

If the VPN is unhealthy, inspect `docker compose logs vpn`.

## 5. Add the Widget to Glance

Copy the widget into your Glance configuration:

```sh
cp courier-widget.yml /path/to/glance/config/widgets/iiith-courier.yml
```

Make these variables available to the Glance container:

```env
IIITH_WIDGETS_PROXY_URL=http://iiith-widgets:8081
TZ=Asia/Kolkata
```

Recreate Glance after changing its environment, then include the widget on a page:

```yaml
widgets:
  - $include: widgets/iiith-courier.yml
```

Glance reloads automatically after the include is added.

[Back to the widget overview](../README.md)
