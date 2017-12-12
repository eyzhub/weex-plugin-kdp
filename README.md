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
Adds the `weex-kdp` plugin to the template.
```html
<weexKdp ref="kdp" playerConfig="{/* playerConfig */}"></weexKdp>
```

## Methods

### `prepare(playerConfig)`
Prepare for playing an entry. Play when it’s ready.
- (JSON) `playerConfig`: see [Data: playerConfig](#playerconfig).
```js
this.$refs.kdp.prepare({ /* player config */})
```

### `play()`
Plays the video.
```js
this.$refs.kdp.play()
```

### `pause()`
Pauses the video.
```js
this.$refs.kdp.pause()
```

### `seek(time)`
Sets the play time of the video.
- (float) time.
```js
this.$refs.kdp.seek(time)
```

### `prepareNext(playerConfig)`
Prepare for playing the next entry.
- (JSON) `playerConfig`: see [Data: playerConfig](#playerconfig).
```js
this.$refs.kdp.prepareNext({ /* player config */})
```

### `loadNext()`
Load the entry that was prepared with [`prepareNext()`](#preparenextplayerconfig), without waiting for the current entry to end.
```js
this.$refs.kdp.loadNext()
```

### `destroy()`
Release player resources.
```js
this.$refs.kdp.destroy()
```

### `selectTrack(trackId)`
Selects a track by `trackId`. See [onTracksAvailable(callback)](#onTracksAvailable(callback)).
- (string) trackId.
```js
this.$refs.kdp.selectTrack(trackId)
```

### `getDuration(callback)`
Returns the duration of the video.
- `callback`: `fn(duration)` callback returning the duration of the video.
  - (float) `duration`
```js
this.$refs.kdp.getDuration((duration) => {
    console.log(duration)
})
```

### `getCurrentAudioTrack(callback)`
Returns the current audio trackId. See [onTracksAvailable(callback)](#ontracksavailablecallback).
- `callback`: `fn(trackId)`
  - (string) `trackId`
```js
this.$refs.kdp.getCurrentAudioTrack((trackId) => {
    console.log(trackId)
})
```

### `getCurrentTextTrack(callback)`
Returns the current text trackId. See [onTracksAvailable(callback)](#onTracksAvailable(callback)).
- `callback`: `fn(trackId)`
  - (string) `trackId`
```js
this.$refs.kdp.getCurrentTextTrack((trackId) => {
    console.log(trackId)
})
```

### `getState(callback)`
Returns the current state of the video.
- `callback`: `fn(duration)` callback returning the state of the video.
  - (string) `state`: the state of the video (`idle`, `loading`, `ready`, `buffering`, `error`)
```js
this.$refs.kdp.getState((state) => {
    console.log(state)
})
```

## Events
### `onTimeChange(callback)`
Updates the callback each 500ms with the current time of the video.
- `callback`: `fn(currentTime)` callback returning the current time of the video.
  - (float) `currentTime`
```js
this.$refs.kdp.onTimeChange((currentTime) => {
    console.log(currentTime)
})
```

### `onCanPlay(callback)`
Sent when enough data is available that the media can be played, at least for a couple of frames.
- `callback`: `fn()`
```js
this.$refs.kdp.onCanPlay(() => {
    console.log('Can Play')
})
```

### `onDurationChanged(callback)`
Sent when enough data is available that the media can be played, at least for a couple of frames.
- `callback`: `fn()`
```js
this.$refs.kdp.onDurationChanged(() => {
    console.log('Duration Changed')
})
```

### `onEnded(callback)`
Sent when playback completes.
- `callback`: `fn()`
```js
this.$refs.kdp.onEnded(() => {
    console.log('Ended')
})
```

### `onLoadedMetadata(callback)`
The media’s metadata has finished loading; all attributes now contain as much useful information as they’re going to.
- `callback`: `fn(metadata)`
```js
this.$refs.kdp.onLoadedMetadata((metadata) => {
    console.log('Loaded Metadata')
})
```

### `onError(callback)`
Sent when an error occurs.
- `callback`: `fn()`
```js
this.$refs.kdp.onError(() => {
    console.log('Error')
})
```

### `onPlay(callback)`
Sent when playback of the media starts after having been paused; that is, when playback is resumed after a prior pause event.
- `callback`: `fn()`
```js
this.$refs.kdp.onPlay(() => {
    console.log('Play')
})
```

### `onPlaying(callback)`
Sent when the media begins to play (either for the first time, after having been paused, or after ending and then restarting).
- `callback`: `fn()`
```js
this.$refs.kdp.onPlaying(() => {
    console.log('Playing')
})
```

### `onPause(callback)`
Sent when playback is paused.
- `callback`: `fn()`
```js
this.$refs.kdp.onPause(() => {
    console.log('Pause')
})
```

### `onSeeking(callback)`
Sent when a seek operation begins.
- `callback`: `fn()`
```js
this.$refs.kdp.onSeeking(() => {
    console.log('Seeking')
})
```

### `onSeeked(callback)`
Sent when a seek operation completes.
- `callback`: `fn()`
```js
this.$refs.kdp.onSeeked(() => {
    console.log('Seeked')
})
```

### `onTracksAvailable(callback)`
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
this.$refs.kdp.onTracksAvailable((tracks) => {
    console.log('Tracks Available', tracks)
})
```

### `onStateChange(callback)`
Updates the callback whenever the state of the video load changes.
- `callback`: `fn(state)`
  - `state` (string): the state of the video load (`idle`, `loading`, `ready`, `buffering`, `error`)
```js
this.$refs.kdp.onStateChange((state) => {
    console.log(state)
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

See [How to develop](./doc/how-to-develop.md).

also,

See the [Plugin Development Guide](https://weex.apache.org/guide/create-a-plugin.html).