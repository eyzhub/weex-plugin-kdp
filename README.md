# weex-kdp
Kaltura Dynamic Player implementation as Weex Components

## Installing the plugin in your project
### Using `weexpack`:
```
weex plugin add weex-kdp
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
Adds the `weex-kdp` plugin to the template. See [Data: playerConfig](#playerconfig).
```html
<weexKdp ref="kdp" playerConfig="{/* playerConfig */}"></weexKdp>
```

## Calling methods

Use the **sendNotification** method to create custom notifications that instruct the player to perform an action, such as play, seek, or pause.

**Example:**
```js
this.$refs.kdp.sendNotification("doSeek", 30);
```

### Available Notifications

#### `prepare`
Prepare for playing an entry. Play when it’s ready.
- (JSON) `playerConfig`: see [Data: playerConfig](#playerconfig).
```js
this.$refs.kdp.sendNotification('prepare', { /* player config */})
```

#### `doPlay`
Plays the video.
```js
this.$refs.kdp.sendNotification('play')
```

#### `doPause`
Pauses the video.
```js
this.$refs.kdp.sendNotification('pause')
```

#### `doSeek`
Sets the play time of the video.
- (float) time.
```js
this.$refs.kdp.sendNotification('seek',time)
```

#### `prepareNext`
Prepare for playing the next entry.
- (JSON) `playerConfig`: see [Data: playerConfig](#playerconfig).
```js
this.$refs.kdp.sendNotification('prepareNext',({ /* player config */})
```

#### `loadNext`
Load the entry that was prepared with [`prepareNext()`](#preparenextplayerconfig), without waiting for the current entry to end.
```js
this.$refs.kdp.sendNotification('loadNext')
```

#### `selectTrack`
Selects a track by `trackId`. See [onTracksAvailable(callback)](#onTracksAvailable(callback)).
- (string) trackId.
```js
this.$refs.kdp.sendNotification('selectTrack', trackId)
```

#### `changeVolume`
Changes the volume. The volume is a value between 0 and 1.
- (float) volume.
```js
this.$refs.kdp.sendNotification('changeVolume', volume)
```

#### `getDuration`
Returns the duration of the video.
- `callback`: `fn(duration)` callback returning the duration of the video.
  - (float) `duration`
```js
this.$refs.kdp.sendNotification('getDuration', duration => {
    console.log(duration)
})
```

#### `getCurrentAudioTrack`
Returns the current audio trackId. See [onTracksAvailable(callback)](#ontracksavailablecallback).
- `callback`: `fn(trackId)`
  - (string) `trackId`
```js
this.$refs.kdp.sendNotification('getCurrentAudioTrack', trackId => {
    console.log(trackId)
})
```

#### `getCurrentTextTrack`
Returns the current text trackId. See [onTracksAvailable(callback)](#onTracksAvailable(callback)).
- `callback`: `fn(trackId)`
  - (string) `trackId`
```js
this.$refs.kdp.sendNotification('getCurrentTextTrack', trackId => {
    console.log(trackId)
})
```

#### `getState`
Returns the current state of the video.
- `callback`: `fn(duration)` callback returning the state of the video.
  - (string) `state`: the state of the video (`idle`, `loading`, `ready`, `buffering`, `error`)
```js
this.$refs.kdp.sendNotification('getState', state => {
    console.log(state)
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

### kUnbind()
Unregister *all* events.
```js
this.$refs.kdp.kUnbind();
```

### Event List

#### `onTimeChange`
Updates the callback each 200ms with the current time of the video.
- `callback`: `fn(currentTime)` callback returning the current time of the video.
  - (float) `currentTime`
```js
this.$refs.kdp.kBind('onTimeChange', (currentTime) => {
    console.log(currentTime)
})
```

#### `playerStateChange`
Dispatched when media player's state has changed.
- `callback`: `fn(playerState)`
  - (string) `playerState`: MediaPlayerState: `uninitialized` / `loading` / `ready` / `playing` / `paused` / `buffering` / `playbackError`
```js
this.$refs.kdp.kBind('playerStateChange', state => {
    console.log('player state: ' + state)
})
```

#### `onDurationChanged`
Sent when enough data is available that the media can be played, at least for a couple of frames.
- `callback`: `fn()`
```js
this.$refs.kdp.kBind('onDurationChanged', newDuration => {
    console.log('Duration Changed to: ' + newDuration)
})
```

#### `onEnded`
Sent when playback completes.
- `callback`: `fn()`
```js
this.$refs.kdp.kBind('onEnded', () => {
    console.log('Ended')
})
```

#### `onLoadedMetadata`
The media’s metadata has finished loading; all attributes now contain as much useful information as they’re going to.
- `callback`: `fn(metadata)`
  - (object) `metadata`
```js
this.$refs.kdp.kBind('onLoadedMetadata', metadata => {
    console.log('Loaded Metadata: ' + JSON.stringify(metadata))
})
```

#### `onSeeking`
Sent when a seek operation begins.
- `callback`: `fn()`
```js
this.$refs.kdp.kBind('onSeeking', () => {
    console.log('Seeking')
})
```

#### `onSeeked`
Sent when a seek operation completes.
- `callback`: `fn()`
```js
this.$refs.kdp.kBind('onSeeked', () => {
    console.log('Seeked')
})
```

#### `onTracksAvailable`
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
this.$refs.kdp.kBind('onTracksAvailable', tracks => {
    console.log('Tracks Available', tracks)
})
```

## Data

### playerConfig
Description of the player configuration. Used in [`prepare`](#prepareplayerconfig) and [`prepareNext`](#preparenextplayerconfig).
A media entry can have multiple sources that would be the same video in different formats. The player will choose the source more appropriate to the device.
```js
{
  mediaEntry: {
    id: 'entryId',
    sources: [
      {
        sourceId: 'sourceId',
        contentUrl: 'url',
        mediaFormat: 'mediaFormat' // e.g. ".hls"
      },
      // ...
    ]
  },
  startTime: 0, // optional, default 0
  subtitleLanguage: "", //optional
  audioLanguage : "" //optional
}
```
# Developing the plugin

See [How to develop](./doc/how-to-develop.md) and the [Plugin Development Guide](https://weex.apache.org/guide/create-a-plugin.html).