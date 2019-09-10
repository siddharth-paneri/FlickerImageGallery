# Flicker Image Gallery
Assignment submission by Siddharth Paneri.

## Assignment details:
Build a simple image gallery application, using publicly available API. The application should support the scenarios below.
Please come up with your own UI & UX keeping in mind that this shouldn’t be the main focus in this task.

#### Gallery
User should be able to see images from Flickr. Please use this url:
```
https://www.flickr.com/services/feeds/docs/photos_public
```
Image metadata should be visible for each picture. Please note that images should be cached.

#### Ordering
User should be able to order images by date taken or date published

#### Search
Search box should appear at the top of image list. It should filter images by tag.

#### Error handling
In case of HTTP connnection error please display Modal dialog with erorr information.

#### Technologies
Application should be written using Java/Kotlin/Swift. Application should be tested.
Limit your usage of 3rd party libraries only to the few ones that add a large benefit to the architecture and testability of the project.
Good example of libraries that could be used are RxSwift, RxJava etc.

#### References
- API resource
```
https://jsonplaceholder.typicode.com/
```

## App's generic architecture
<img src = "https://github.com/siddharth-paneri/FlickerImageGallery/blob/master/Media/Architecture.jpg"/>

## Design patterns & programming concepts used
1. MVVM
2. Protocol-oriented programming
3. Singleton pattern
4. Dependency injection

## Features implemented
1. Fetch all the public photos from Flicker api.
2. Display all the public photos in a list/grid based on user preference.
3. Allow user to perform sorting based on chronology for dates of photo published and photo taken.
4. See the detail of each photo, able to see tags on that photo.
5. Able to share the photo and link ot it via native content share option.
6. Use can pull to refresh the content.
7. User can search based on tags.
8. All the images are being cached.
9. All the publc photo feeds are also being stored locally in core data.


## App screenshots
<img src = "https://github.com/siddharth-paneri/FlickerImageGallery/blob/master/Media/IMG_1.png" width="200"/>    <img src = "https://github.com/siddharth-paneri/FlickerImageGallery/blob/master/Media/IMG_2.png" width="200"/>    <img src = "https://github.com/siddharth-paneri/FlickerImageGallery/blob/master/Media/IMG_3.png" width="200"/>    <img src = "https://github.com/siddharth-paneri/FlickerImageGallery/blob/master/Media/IMG_4.png" width="200"/>    <img src = "https://github.com/siddharth-paneri/FlickerImageGallery/blob/master/Media/IMG_5.png" width="200"/>    <img src = "https://github.com/siddharth-paneri/FlickerImageGallery/blob/master/Media/IMG_6.png" width="200"/>    <img src = "https://github.com/siddharth-paneri/FlickerImageGallery/blob/master/Media/IMG_7.png" width="200"/>
 

## Test envirnment
This code has been tested on iPhone XR, iPhone X & iPhone 6s.

## Future Improvements
1. Able to perform Flicker api search.
2. Able to zoom in the photo
3. Able to see all photos posted by an author
4. Allow the flicker tags clickable searchble over api.
5. Update tag based searching locally, for all comma seaperated values, currently it searches complete string as a whole
6. Make image caching robust (so in case of memory warnings we can clear out cache).
7. Be able to use Swift’s Codable protocol to parse data automatically (its manual right now).

