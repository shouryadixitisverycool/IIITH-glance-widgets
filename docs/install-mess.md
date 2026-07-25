# Today's Mess

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

## 3. Add the Mess API Key

Create a key under **Settings -> API Keys** in the Mess Portal, then set it in `proxy.env`:

```env
MESS_API_KEY=your-mess-portal-api-key
```

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
cp mess-widget.yml /path/to/glance/config/widgets/iiith-mess.yml
```

Make these variables available to the Glance container:

```env
IIITH_WIDGETS_PROXY_URL=http://iiith-widgets:8081
TZ=Asia/Kolkata
```

Recreate Glance after changing its environment, then include the widget on a page:

```yaml
widgets:
  - $include: widgets/iiith-mess.yml
```

Glance reloads automatically after the include is added. Test the route from its container with:

```sh
docker exec glance wget -qO- http://iiith-widgets:8081/api/registration
```

[Back to the widget overview](../README.md)
