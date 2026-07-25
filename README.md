# IIITH Glance Widgets

> [!WARNING]
>
> This project is still in active development so expect stuff to not work and break if you still install it.

A collection of [Glance](https://github.com/glanceapp/glance) widgets for IIIT related things. This includes mess registrations, pending couriers, and Moodle assignment deadlines.

## Widgets

### Today's Mess

See all four meal registrations at a glance.


#### Properties

| Name | Type | Required | Default |
| --- | --- | --- | --- |
| `timingMess` | string | no | `yuktahar` |
| `collapseAfter` | integer | no | `6` |
| `menu` | boolean | no | `true` |
| `style` | string | no | `default` |
| `category-whitelist` | array | no | `[]` |
| `category-blacklist` | array | no | `[]` |

##### `timingMess`

The mess whose serving schedule determines the ongoing or next meal.

##### `collapseAfter`

The number of menu items to show before the "SHOW MORE" button appears.

##### `menu`

Whether to show the selected meal's menu.

##### `style`

Used to change the appearance of the widget. Possible values are `default`, `bubbles`, and `singular`.

Style previews by meal state. Click a screenshot to view it at full size.

| State | `default` | `bubbles` | `singular` |
| --- | --- | --- | --- |
| Yuktahar | [<img src="assets/mess/default-yuk.png" alt="Default style showing Yuktahar" width="240">](assets/mess/default-yuk.png) | [<img src="assets/mess/bubbles-yuk.png" alt="Bubbles style showing Yuktahar" width="240">](assets/mess/bubbles-yuk.png) | [<img src="assets/mess/singular-yuk.png" alt="Singular style showing Yuktahar" width="240">](assets/mess/singular-yuk.png) |
| Yuktahar (J) | [<img src="assets/mess/default-yuk-j.png" alt="Default style showing Yuktahar Jain" width="240">](assets/mess/default-yuk-j.png) | [<img src="assets/mess/bubbles-yuk-j.png" alt="Bubbles style showing Yuktahar Jain" width="240">](assets/mess/bubbles-yuk-j.png) | [<img src="assets/mess/singular-yuk-j.png" alt="Singular style showing Yuktahar Jain" width="240">](assets/mess/singular-yuk-j.png) |
| Kadamb (V) | [<img src="assets/mess/default-v.png" alt="Default style showing Kadamb vegetarian" width="240">](assets/mess/default-v.png) | [<img src="assets/mess/bubbles-v.png" alt="Bubbles style showing Kadamb vegetarian" width="240">](assets/mess/bubbles-v.png) | [<img src="assets/mess/singular-v.png" alt="Singular style showing Kadamb vegetarian" width="240">](assets/mess/singular-v.png) |
| Kadamb (NV) with extra | [<img src="assets/mess/default-nv-extra.png" alt="Default style showing Kadamb non-vegetarian with an extra" width="240">](assets/mess/default-nv-extra.png) | [<img src="assets/mess/bubbles-nv-extra.png" alt="Bubbles style showing Kadamb non-vegetarian with an extra" width="240">](assets/mess/bubbles-nv-extra.png) | [<img src="assets/mess/singular-nv-extra.png" alt="Singular style showing Kadamb non-vegetarian with an extra" width="240">](assets/mess/singular-nv-extra.png) |
| Skipped | [<img src="assets/mess/default-skip.png" alt="Default style showing a skipped meal" width="240">](assets/mess/default-skip.png) | [<img src="assets/mess/bubbles-skip.png" alt="Bubbles style showing a skipped meal" width="240">](assets/mess/bubbles-skip.png) | [<img src="assets/mess/singular-skip.png" alt="Singular style showing a skipped meal" width="240">](assets/mess/singular-skip.png) |
| Cancelled | [<img src="assets/mess/default-cancel.png" alt="Default style showing a cancelled meal" width="240">](assets/mess/default-cancel.png) | - | [<img src="assets/mess/singular-cancel.png" alt="Singular style showing a cancelled meal" width="240">](assets/mess/singular-cancel.png) |
| Not registered | [<img src="assets/mess/default-noreg.png" alt="Default style showing an unregistered meal" width="240">](assets/mess/default-noreg.png) | [<img src="assets/mess/bubbles-noreg.png" alt="Bubbles style showing an unregistered meal" width="240">](assets/mess/bubbles-noreg.png) | [<img src="assets/mess/singular-noreg.png" alt="Singular style showing an unregistered meal" width="240">](assets/mess/singular-noreg.png) |

##### `category-whitelist`

Only show menu categories in this list. Matching is case-insensitive and supports slash-separated category names.

##### `category-blacklist`

Hide menu categories in this list. It cannot be used together with `category-whitelist`.

[Installation Instructions](docs/install-mess.md)

### My Couriers

See every package awaiting collection with its courier provider and relative arrival time.

#### Properties

| Name | Type | Required | Default |
| --- | --- | --- | --- |
| `collapseAfter` | integer | no | `3` |

##### `collapseAfter`

The number of couriers to show before the "SHOW MORE" button appears.

[Installation Instructions](docs/install-courier.md)

### Moodle Timeline

Keep upcoming Moodle assignment deadlines on your dashboard, with direct links, exact due dates, and relative countdowns. The default view includes up to 10 events from the next 60 days and collapses after five.

#### Properties

| Name | Type | Required | Default |
| --- | --- | --- | --- |
| `url` | string | yes | |
| `limit` | integer | no | `10` |
| `lookback_days` | integer | no | `0` |
| `horizon_days` | integer | no | `60` |
| `collapseAfter` | integer | no | `5` |

##### `url`

The Moodle iCalendar feed URL, supplied through `MOODLE_ICAL_URL`.

##### `limit`

The maximum number of assignments to return.

##### `lookback_days`

The number of days before today to include.

##### `horizon_days`

The number of days ahead to include.

##### `collapseAfter`

The number of assignments to show before the "SHOW MORE" button appears.

[Installation Instructions](docs/install-moodle.md)

## How It Works

```text
Glance -> iiith-widgets:8081 -> Caddy -> IIITH OpenVPN -> Mess/Courier APIs
Glance -> iiith-widgets:8081 -> Caddy -> iCal helper -> IIITH OpenVPN -> Moodle calendar
   |
   +-> every other widget -> normal Docker/host internet route
```

The VPN, proxy, and iCal helper share one isolated network namespace. OpenVPN installs only IIITH private-network routes, so neither the host nor unrelated Glance widgets are sent through the college VPN.

## Security

- Caddy accepts only `GET` requests to the exact Mess and Courier API paths used by the widgets.
- Moodle requests are restricted to calendar URLs on `courses.iiit.ac.in`.
- Registration, cancellation, billing, profile, feedback, and other account endpoints return `403`.
- Mess and Courier credentials exist only in the proxy container.
- VPN credentials exist only in the VPN container.
- The Moodle calendar URL is passed only to Glance and the iCal helper.
- The proxy has no published host port and is reachable only from the shared Docker network.

## Credits

Mess API behavior and endpoint discovery are based on [NJP6969/IIITH-mess-MCP](https://github.com/NJP6969/IIITH-mess-MCP).
Moodle calendar parsing uses [AWildLeon/Glance-iCal-Events](https://github.com/AWildLeon/Glance-iCal-Events).

## License

[MIT](LICENSE)
