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

## Developing the plugin

See [How to develop](./doc/how-to-develop.md).

also,

See the [Plugin Development Guide](https://weex.apache.org/guide/create-a-plugin.html).