# dgis_mobile_sdk_map

Map version of DGisMobileSDK for Flutter

This package allows you to add a [2GIS map](https://2gis.ru/) to your application. Using this SDK, you can display a map on the screen, add markers to it, draw geometric shapes, build routes, get information about objects, control the camera, and so on.

Map data supports [OGC standards](https://ru.wikipedia.org/wiki/Open_Geospatial_Consortium).

## Obtaining access keys

To work with the SDK, you need to obtain a key file `dgissdk.key` with the obligatory indication of `appId` of the application for which this key is being created. The key will be used to connect to 2GIS servers, obtain geographic data, as well as to use offline and the navigator. This key is unique to this type of SDK and cannot be used with other SDKs from 2GIS.

To get the key file:

1. Fill out the form on [dev.2gis.ru](https://dev.2gis.ru/order/).
1. Add the resulting key file to the application's `assets`.

After activating the key, you can register in your personal account [Platform Manager](https://platform.2gis.ru/) and view request distribution statistics.

## Installation

### Android

When building for Android, a binary artifact in the `.aar` format is used. To connect correctly, you need to add a repository with this artifact to the `build.gradle` of your application:

```gradle
repositories {
    maven {
        url "https://artifactory.2gis.dev/sdk-maven-release"
    }
}
```

## Example app

This package provides an example of usage in the form of an application located in the `example` folder. 

Before running the app, ensure you add your obtained dgissdk.key file to the assets folder of the application.
