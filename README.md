# weex-kdp
Kaltura Dynamic Player implementation as Weex Components

## Installing the plugin in your project
### Using `weexpack`:
```
weex plugin add weex-plugin-kdp
```

### Manual integration:
#### iOS:
```
pod 'WeexKdp'
```

#### Android:
Add the following line to the dependencies list in the build.gradle file for the corresponding project.
```
 compile '${groupId}:weexkdp:{$version}'
```
> Note: You need to specify the groupId and $version of the project.

#### Web integration
```
 npm install weexkdp
```

# API

## Template
### `<weex-kdp>`
Adds the `weex-kdp` plugin to the template. See [Data: MediaEntry](#MediaEntry).
```html
<weexKdp ref="kdp" MediaEntry="{/* MediaEntry */}"></weexKdp>
```

## Calling methods

Use the **sendNotification** method to create custom notifications that instruct the player to perform an action, such as play, seek, or pause.

**Example:**
```js
this.$refs.kdp.sendNotification("doSeek", 30);
```

### Available Notifications

#### `changeMediaEntry` *(ios)*
Prepare for playing an entry. Play when it’s ready.
- (JSON) `MediaEntry`: see [Data: MediaEntry](#mediaentry).
```js
this.$refs.kdp.sendNotification('prepare', { /* media entry */});
```

#### `doPlay` *(iOS)*
Plays the video.
```js
this.$refs.kdp.sendNotification('doPlay')
```

#### `doPause` *(iOS)*
Pauses the video.
```js
this.$refs.kdp.sendNotification('doPause')
```

#### `doSeek` *(iOS)*
Sets the play time of the video.
- (float) time.
```js
this.$refs.kdp.sendNotification('doSeek',time)
```

#### `changeVolume` *(NOT IMPLEMENTED)*
Changes the volume. The volume is a value between 0 and 1.
- (float) volume.
```js
this.$refs.kdp.sendNotification('changeVolume', volume)
```

#### `selectTrack` *(NOT IMPLEMENTED)*
Selects a track by `trackId`. See [tracksAvailable(callback)](#tracksAvailable(callback)).
- (string) trackId.
```js
this.$refs.kdp.sendNotification('selectTrack', trackId)
```

## Getting player properties

Use the **getProperty** method to retrieve data from the plugin, such as `duration`, `time`, `state`, `audioTrack`, `textTrack`,

#### `duration` *(iOS)*
Returns the duration of the video.
- `callback`: `fn(duration)` callback returning the duration of the video.
  - (float) `duration`
```js
this.$refs.kdp.getProperty('duration', duration => {
    console.log(duration)
})
```

#### `time` *(iOS)*
Returns the current play time of the video.
- `callback`: `fn(duration)` callback returning the plat time of the video.
  - (float) `time`: play time of the video
```js
this.$refs.kdp.getProperty('time', time => {
    console.log(time)
})
```

#### `state` *(NOT IMPLEMENTED)*
Returns the current state of the video.
- `callback`: `fn(duration)` callback returning the state of the video.
  - (string) `state`: the state of the video (`idle`, `loading`, `ready`, `buffering`, `error`)
```js
this.$refs.kdp.getProperty('state', state => {
    console.log(state)
})
```

#### `textTrack` *(NOT IMPLEMENTED)*
Returns the current text trackId. See [tracksAvailable(callback)](#tracksAvailable(callback)).
- `callback`: `fn(trackId)`
  - (string) `trackId`
```js
this.$refs.kdp.getProperty('textTrack', trackId => {
    console.log(trackId)
})
```

#### `audioTrack` *(NOT IMPLEMENTED)*
Returns the current audio trackId. See [tracksAvailable(callback)](#tracksavailablecallback).
- `callback`: `fn(trackId)`
  - (string) `trackId`
```js
this.$refs.kdp.sendNotification('audioTrack', trackId => {
    console.log(trackId)
})
```

## Listening to Events

Register player events with `kBind` and unregister events with `kUnbind`.

### kBind(eventName, callback)
Registers an event.
- `eventName`: name of the event (See [Event List](#eventlist)).
- `callback`: `fn(eventData)` callback of the event.
```js
this.$refs.kdp.kBind('onTimeChange', time => {
		// time = the player's progress time in seconds
	});
```

### kUnbind(eventName)
Unregister an event.
- `eventName`: name of the event (See [Event List](#eventlist)).
```js
this.$refs.kdp.kUnbind('onTimeChange');
```

### Event List

#### `timeChange` *(iOS)*
Updates the callback each 500ms with the current time of the video.
- `callback`: `fn(currentTime)` callback returning the current time of the video.
  - (float) `currentTime`
```js
this.$refs.kdp.kBind('timeChange', (currentTime) => {
    console.log(currentTime)
})
```

#### `stateChange` *(iOS)*
Dispatched when media player's state has changed.
- `callback`: `fn(playerState)`
  - (string) `playerState`: MediaPlayerState: `uninitialized` / `loading` / `ready` / `playing` / `paused` / `buffering` / `playbackError`
```js
this.$refs.kdp.kBind('stateChange', state => {
    console.log('player state: ' + state)
})
```

#### `durationChanged` *(NOT IMPLEMENTED)*
Sent when enough data is available that the media can be played, at least for a couple of frames.
- `callback`: `fn()`
```js
this.$refs.kdp.kBind('durationChanged', newDuration => {
    console.log('Duration Changed to: ' + newDuration)
})
```

#### `ended` *(NOT IMPLEMENTED)*
Sent when playback completes.
- `callback`: `fn()`
```js
this.$refs.kdp.kBind('ended', () => {
    console.log('Ended')
})
```

#### `loadedMetadata` *(NOT IMPLEMENTED)*
The media’s metadata has finished loading; all attributes now contain as much useful information as they’re going to.
- `callback`: `fn(metadata)`
  - (object) `metadata`
```js
this.$refs.kdp.kBind('loadedMetadata', metadata => {
    console.log('Loaded Metadata: ' + JSON.stringify(metadata))
})
```

#### `seeking` *(NOT IMPLEMENTED)*
Sent when a seek operation begins.
- `callback`: `fn()`
```js
this.$refs.kdp.kBind('seeking', () => {
    console.log('Seeking')
})
```

#### `seeked` *(NOT IMPLEMENTED)*
Sent when a seek operation completes.
- `callback`: `fn()`
```js
this.$refs.kdp.kBind('seeked', () => {
    console.log('Seeked')
})
```

#### `tracksAvailable` *(NOT IMPLEMENTED)*
Sent when tracks available.
- `callback`: `fn(tracks)`
  - (JSON) `tracks`: JSON with the available tracks in the format:
  ```js
  {
    audioTracks: [
      {
        id: "id",
        title: "title",
        language: "language"
      },
      (...)
    ],
    textTracks: [
      {
        id: "id",
        title: "title",
        language: "language"
      },
      (...)
  }
  ```
```js
this.$refs.kdp.kBind('tracksAvailable', tracks => {
    console.log('Tracks Available', tracks)
})
```

## Data

### MediaEntry
Description of the player configuration. Used in [`prepare`](#preparemediaentry) and [`prepareNext`](#preparenextmediaentry).
A media entry can have multiple sources that would be the same video in different formats. The player will choose the source more appropriate to the device.
```js
{
    id: 'entryId',
    sources: [
      {
        contentUrl: 'url',
        mediaFormat: 'mediaFormat' // e.g. ".hls"
      }
    ]
}
```
# Developing the plugin

See [How to develop](./doc/how-to-develop.md) and the [Plugin Development Guide](https://weex.apache.org/guide/create-a-plugin.html).
