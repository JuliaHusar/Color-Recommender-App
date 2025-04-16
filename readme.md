Original App Design Project - README Template
===

# Music Color Recommendation App

## Table of Contents

1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Wireframes](#Wireframes)
4. [Schema](#Schema)

## Overview

### Users can take pictures of their outfit, and then combined with an existing profile of a user's music taste, a recommender system can recommend certain albums based on matches between an album color and clothes that a user is wearing. This will primarily work by matching a user's taste with colors on different album covers from a large dataset.


### App Evaluation

[Evaluation of your app across the following attributes]
- **Category:** Interest-Based Networks
   - **Mobile:** Mobile is needed for the ability to easily save visualizations on phone, interact with visualizations using touch, and share visualizations with friends and on social networks.
   - **Story:** Allows you to examine your music tastes from a new angle, and share your general tastes with friends.
   - **Market:** Users of modern streaming apps and social networking apps, who like discovering new music
   - **Habit:** Users might check this app once a week or once a day depending on how often they want to change visualizations to send to friends.
   - **Scope:** V1 will allow users to see simple time series visualizations of favorite artists/albums. V2 will feature more complex custom visualizations that show networks between different albums. V3 will feature an entire development environment for creating visualizations.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* As a user I want to be recommended albums from genres I already like, but haven't explored fully.
* As a user I want to know why the recommendation system decided to match an album with my shirt
* As a user I want to have some degree over the algorithm and fine tune from my phone.

### 2. Screen Archetypes

- [ ] Music Taste Screen
* As a user I want the recommender system to have some background knowledge of genres and artists I'm interested in, whether it be through my listening history or information I provide them.
* ...
- [ ] Home Screen
    As a user I want to be able to see information about potential albums I might be interested on based on a picture I have taken.
- [ ] Calendar Screen
    As a user I want to be able to see historical recommendations based on previous pictures I submitted to the server.


### 3. Navigation

**Tab Navigation** (Tab to Screen)

*  Home
*  Camera
*  Calendar

**Flow Navigation** (Screen to Screen)

- [X] Home
* Home to camera to take a picture
* ...
- [X] Camera
* Camera to home to view results
* ...
- [X] Details
Home to Detail View to view details about picture

## Wireframes

[Add picture of your hand sketched wireframes in this section]
<img src="/low-fidelity.jpg" width=600>


## Schema 


### Models
![recording](https://github.com/JuliaHusar/Color-Recommender-App/blob/main/recording.gif?raw=true)
struct LastFMResponse
| Name     | Type |
| -------- | ------- |
| dominant_colors_hsv  | [[Double]]    |
| dominant_colors_rgb  | [[Int]]       |
| top_ten_albums       | TopTenAlbums  |
| error                | String        |

struct TopTenAlbums
| Name     | Type |
| -------- | ------- |
| topalbums  | AlbumsInfo    |

struct Album
| Name     | Type |
| -------- | -------   |
| name   | String      |
| artist | Artist      |
| image  | LastFMImage |

struct Artist
| Name     | Type |
| -------- | ------- |
| mbid  | String  |
| name  | String  |
| url   | String  |

struct LastFMImage
| Name     | Type |
| -------- | ------- |
| text  | String |
| url   | String |
| size  | String |


****

### Networking

- [Add list of network requests by screen ]
  **HomeViewController**
  - post(image) -> httpbody.response = HSV Color Values, RGB Color Values, LastFMAPI JSON
  **SignUpOneController
   - post (username, password) -> httpbody.response = success
- [Create basic snippets for each Parse network request]
   if (200...299).contains(httpResponse.statusCode) {
                    do{
                        let decoder = JSONDecoder()
                        let lastFMResponse = try decoder.decode(LastFMResponse.self, from: data)
                        print("LastFM Response Object: \(lastFMResponse)")
                        completion(lastFMResponse)
                    } catch {
                        print(error)
                        completion(nil)
                    }
                } 
**Endpoint**
  https://colormatcherflask.onrender.com/process-image
## Sprints

[X] **Sprint 1:** Setup navigation for the application, and the basic color scheme of the app. Import any necessary icons, elements, and work on the UI of this app.  
[X] **Sprint 2:** Setup integration with User's LastFM, Spotify, or Apple Music account, and then construct algorithm to define user's "taste"  
[X] **Sprint 3:** Connect client iOS app to color matcher endpoint, and write logic to send post request of image + get request with data from endpoint.  
[X] **Sprint 4:** Display whatever data is received from server, and allow user to save an image every single day into local storage  
