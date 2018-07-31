---
layout: post
title: "Bing Maps API - Rest Locations (Geocoding)"
date: 2018-07-31 17:00:00
categories: geoprocessing
tags: bing maps api geocoding
comments: true
---

The [Bing Maps APIs][bing-maps-apis] provide a [REST API for Geocoding][bing-maps-api-locations], hence finding a location based on a text input. This text input can be either a structured address or an (unstructured) search query. In this blog post we will see how to request a developer key and use the REST API for finding the coordinates to a query using the Bing Maps Location API.

## Request an API key

If you already use Azure or have an Azure account, then you can request an API key directly from within Azure. To do so, log into your Azure account and go to the Marketplace. Search for *Bing Maps API for Enterprise*, select your pricing model and add it to your Azure account. The tier level 1 is free and grants you 10K requests/month. You can find more pricing information in the [product documentation][bing-maps-api-pricing].

If you don't have an Azure account then you can request an API key from the [Bing Maps Portal][bing-maps-portal].

## Locations API (Rest)

There are 2 types of queries available in the Locations API, structured and unstructured queries. In this example we will use an unstructured query to query the API with a search term. However, you can also find examples using structured queries on the [Bing Maps Location API][bing-maps-api-locations] documentation.

Let's find the geolocation of Howth an Irish village in east central Dublin.

```sh
$ curl http://dev.virtualearth.net/REST/v1/Locations?query=Howth+Dublin&include=queryParse&key=accesskey&output=json

{
  "authenticationResultCode": "ValidCredentials",
  "brandLogoUri": "http://dev.virtualearth.net/Branding/logo_powered_by.png",
  "copyright": "Copyright © 2018 Microsoft and its suppliers. All rights reserved. This API cannot be accessed and the content and any results may not be used, reproduced or transmitted in any manner without express written permission from Microsoft Corporation.",
  "resourceSets": [
    {
      "estimatedTotal": 2,
      "resources": [
        {
          "__type": "Location:http://schemas.microsoft.com/search/local/ws/rest/v1",
          "bbox": [
            53.3509009854156,
            -6.12213139880203,
            53.4088417514008,
            -5.99270815503098
          ],
          "name": "Howth, Ireland",
          "point": {
            "type": "Point",
            "coordinates": [
              53.3798713684082,
              -6.0574197769165
            ]
          },
          "address": {
            "adminDistrict": "Dublin",
            "countryRegion": "Ireland",
            "formattedAddress": "Howth, Ireland",
            "locality": "Howth"
          },
          "confidence": "High",
          "entityType": "PopulatedPlace",
          "geocodePoints": [
            {
              "type": "Point",
              "coordinates": [
                53.3798713684082,
                -6.0574197769165
              ],
              "calculationMethod": "Rooftop",
              "usageTypes": [
                "Display"
              ]
            }
          ],
          "matchCodes": [
            "Ambiguous"
          ],
          "queryParseValues": [
            {
              "property": "Locality",
              "value": "howth"
            },
            {
              "property": "AdminDistrict",
              "value": "dublin"
            }
          ]
        },
        {
          "__type": "Location:http://schemas.microsoft.com/search/local/ws/rest/v1",
          "bbox": [
            53.3849579306227,
            -6.08322532103279,
            53.392683365764,
            -6.06595509125969
          ],
          "name": "Howth, Ireland",
          "point": {
            "type": "Point",
            "coordinates": [
              53.3888206481934,
              -6.07459020614624
            ]
          },
          "address": {
            "adminDistrict": "Dublin",
            "countryRegion": "Ireland",
            "formattedAddress": "Howth, Ireland",
            "locality": "Howth"
          },
          "confidence": "Medium",
          "entityType": "RailwayStation",
          "geocodePoints": [
            {
              "type": "Point",
              "coordinates": [
                53.3888206481934,
                -6.07459020614624
              ],
              "calculationMethod": "Rooftop",
              "usageTypes": [
                "Display"
              ]
            }
          ],
          "matchCodes": [
            "Ambiguous"
          ],
          "queryParseValues": [
            {
              "property": "Landmark",
              "value": "howth"
            },
            {
              "property": "AdminDistrict",
              "value": "dublin"
            }
          ]
        }
      ]
    }
  ],
  "statusCode": 200,
  "statusDescription": "OK",
  "traceId": "40fdef3af24f4784ace0cce7eac525d8|DB40060332|7.7.0.0|Ref A: 4E51EFC390E74430B0E957794757DF59 Ref B: DB3EDGE1021 Ref C: 2018-07-31T13:59:46Z"
}
```

In the above code we see that the API returns the geolocation, a bounding box and other useful geo information such as country region and administrative district as a json body.

> With the Bing Maps API, one can also perform Batch operations. You can find more information about Batch operations on the [Bing Blog](https://blogs.bing.com/maps/2010/08/31/batch-geocoding-and-batch-reverse-geocoding-with-bing-maps/).

## Resources

* [Bing Maps API Overview][bing-maps-apis]
* [Bing Maps API - Documentation of Locations API][bing-maps-api-locations]
* [Bing Maps API - Pricing][bing-maps-api-pricing]
* [Bing Maps Portal][bing-maps-portal]

[bing-maps-apis]: https://www.microsoft.com/en-us/maps/choose-your-bing-maps-api
[bing-maps-api-locations]: https://msdn.microsoft.com/en-us/library/ff701711.aspx
[bing-maps-api-pricing]: https://azuremarketplace.microsoft.com/en-us/marketplace/apps/bingmaps.mapapis?tab=PlansAndPrice
[bing-maps-portal]: https://www.bingmapsportal.com/