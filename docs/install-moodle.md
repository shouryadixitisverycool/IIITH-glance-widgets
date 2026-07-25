# Moodle Timeline

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

Protect the credentials and generated profile:

```sh
chmod 600 vpn.env proxy.env iiith.ovpn
```

Never commit these files.

## 3. Export the Moodle Calendar

Head over to the [Calendar Export Page](https://courses.iiit.ac.in/calendar/export.php?) on Moodle, select your preferred events and time period, then copy the generated iCal URL. Keep it private because it contains an access token.


## 4. Start the iCal Helper

```sh
docker compose up -d vpn proxy ical-api
docker compose ps
```

If the VPN is unhealthy, inspect `docker compose logs vpn`.

## 5. Add the Widget to Glance

Copy the widget into your Glance configuration:

```sh
cp moodle-assignments.yml /path/to/glance/config/widgets/moodle-assignments.yml
```

Make these variables available to the Glance container:

```env
MOODLE_ICAL_URL=https://courses.iiit.ac.in/calendar/export_execute.php?...
TZ=Asia/Kolkata
```

Recreate Glance after changing its environment, then include the widget on a page:

```yaml
widgets:
  - $include: widgets/moodle-assignments.yml
```

Glance reloads automatically after the include is added.

[Back to the widget overview](../README.md)
