# CropBook

[![CropBook](https://img.youtube.com/vi/GbgbS9BZ9V0/0.jpg)](https://www.youtube.com/watch?v=GbgbS9BZ9V0 "CropBook")

Video: https://www.youtube.com/watch?v=GbgbS9BZ9V0


## Gardening Made Easy
CropBook is a gardener’s multi-purpose tool. The iOS application provides a number of different features geared towards garden resource management. 

<ul>
<li>Daily watering recommendations based on monitored weather activity </li>


<li>Create garden profiles to track each plant’s approach to harvest  </li>

<li>Share a crop’s profile and invite others to fill a role in the crop’s maintenance</li>

<li>Knowledge base for plant requirements and soil information</li>
</ul>


### Cocoapods Setup Guide

```
sudo gem install cocoapods
pod setup -verbose

// go to project directory
pod init
open -a Xcode Podfile

//in the pod file add the following under ‘Pods for “project”’
pod ‘AerisWeather’
pod 'Firebase'
pod 'FirebaseDatabase'
pod 'MultiSelectSegmentedControl'

//after saving pod file, go back to terminal
pod install

//Open .workspace file and you’re done kid
```

### Credits
Bowen He
Jonathan Antepyan
Jason Wu
