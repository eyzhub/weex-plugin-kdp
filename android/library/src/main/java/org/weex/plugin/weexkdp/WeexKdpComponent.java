package org.weex.plugin.weexkdp;


import android.content.Context;
import android.graphics.Color;
import android.os.Handler;
import android.support.annotation.ColorInt;
import android.support.annotation.NonNull;
import android.util.Log;
import android.view.View;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONException;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.weex.plugin.annotation.WeexComponent;
import com.kaltura.playkit.PKEvent;
import com.kaltura.playkit.PKMediaConfig;
import com.kaltura.playkit.PKMediaEntry;
import com.kaltura.playkit.PKMediaFormat;
import com.kaltura.playkit.PKMediaSource;
import com.kaltura.playkit.PlayKitManager;
import com.kaltura.playkit.Player;
import com.kaltura.playkit.PlayerEvent;
import com.kaltura.playkit.PlayerState;
import com.kaltura.playkit.utils.Consts;
import com.taobao.weex.WXSDKInstance;
import com.taobao.weex.annotation.JSMethod;
import com.taobao.weex.bridge.JSCallback;
import com.taobao.weex.dom.WXDomObject;
import com.taobao.weex.ui.component.WXComponent;
import com.taobao.weex.ui.component.WXComponentProp;
import com.taobao.weex.ui.component.WXVContainer;


import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * TODO: Auto-generated component example
 */

@WeexComponent(names = {"weexKdp"})
public class WeexKdpComponent extends WXComponent<View> {

    private static final String TAG = "WeexKdpComponent";

    //The url of the source to play
    private static final String SOURCE_URL = "https://cdnapisec.kaltura.com/p/2215841/sp/221584100/playManifest/entryId/1_w9zx2eti/protocol/https/format/applehttp/falvorIds/1_1obpcggb,1_yyuvftfz,1_1xdbzoa6,1_k16ccgto,1_djdf6bk8/a.m3u8";

    private static final String ENTRY_ID = "1_w9zx2eti";
    private static final String MEDIA_SOURCE_ID = "source_id";

    private Player player;
    private PlayerState playerState;

    private PKMediaConfig mediaConfig;

    private HashMap<String, JSCallback> eventCallbacks = new HashMap<>();

    public WeexKdpComponent(WXSDKInstance instance, WXDomObject dom, WXVContainer parent) {
        super(instance, dom, parent);
    }

    @Override
    protected View initComponentHostView(@NonNull Context context) {
        player = PlayKitManager.loadPlayer(context, null);

        return player.getView();
    }

    @WXComponentProp(name = "playerConfig")
    public void setPlayerConfig(Map playerConfig) {
        Log.d(TAG, playerConfig.toString());

        createMediaConfig(playerConfig);
        player.prepare(mediaConfig);

        addPlayerListeners();
    }

    @JSMethod
    public void sendNotification(String action, Object data) {
        Log.d(TAG, action + ": " + (data != null ? data.toString() : ""));

        switch (action) {
            case "doPlay": play(); break;
            case "doPause": pause(); break;
            case "doSeek": doSeek(data != null ? ((BigDecimal) data).intValue() : 0); break;
            case "changeMediaEntry": setPlayerConfig((Map) data); break;
        }
    }

    @JSMethod
    public void getProperty(String property, JSCallback callback) {
        Log.d(TAG, "get " + property);

        switch (property) {
            case "duration":    callback.invoke(getDuration()); break;
            case "time":        callback.invoke(getTime());     break;

        }
        callback.invoke(0);
    }

    @JSMethod
    public void kBind(String event, JSCallback callback) {
        eventCallbacks.put(event, callback);
    }

    @JSMethod
    public void kUnbind(String event) {
        eventCallbacks.remove(event);
    }

    private void updateProgress() {
        Log.d(TAG, "updateProgress");
        long duration = Consts.TIME_UNSET;
        long position = Consts.POSITION_UNSET;
        long bufferedPosition = 0;

        if (player != null) {
            duration = player.getDuration();
            position = player.getCurrentPosition();
            bufferedPosition = player.getBufferedPosition();
        }

        updatePlayerTime(position);

//        timeHandler.removeCallbacks(updateProgressAction);
//        // Schedule an update if necessary.
//        if (playerState != PlayerState.IDLE /*|| (player.getController(AdEnabledPlayerController.class)  != null && player.getController(AdEnabledPlayerController.class) .getAdCurrentPosition() >= 0)*/) {
//            long delayMs = 500;
//            timeHandler.postDelayed(updateProgressAction, delayMs);
//        }
    }

    private void updatePlayerTime(long position) {
        JSCallback stateCallback = eventCallbacks.get("timeChange");
        if (stateCallback != null) {
            stateCallback.invokeAndKeepAlive((float) position / 1000);
        }
    }

    private void updatePlayerState(String playerState) {
        JSCallback stateCallback = eventCallbacks.get("stateChange");
        if (stateCallback != null) {
            stateCallback.invokeAndKeepAlive(playerState.toLowerCase());
        }
    }

    private void play() {
        player.play();
    }

    private void pause() {
        player.pause();
    }

    private void doSeek(float time) {
        player.seekTo((long) (time * 1000));
    }

    private void changeMediaEntry(Map mediaEntry) {

    }

    private float getDuration() {
        return (float) player.getDuration()/1000;
    }

    private long getTime() {
        return player.getCurrentPosition();
    }


    private void addPlayerListeners() {

        player.addEventListener(new PKEvent.Listener() {
            @Override
            public void onEvent(PKEvent event) {
                updatePlayerState("playing");
            }
        }, PlayerEvent.Type.PLAY);

        player.addEventListener(new PKEvent.Listener() {
            @Override
            public void onEvent(PKEvent event) {
                updatePlayerState("playing");
            }
        }, PlayerEvent.Type.PLAYING);


        player.addEventListener(new PKEvent.Listener() {
            @Override
            public void onEvent(PKEvent event) {
                updatePlayerState("paused");
            }
        }, PlayerEvent.Type.PAUSE);


        player.addStateChangeListener(new PKEvent.Listener() {
            @Override
            public void onEvent(PKEvent event) {
                if (event instanceof PlayerEvent.StateChanged) {
                    PlayerEvent.StateChanged stateChanged = (PlayerEvent.StateChanged) event;
                    Log.d(TAG, "State changed from " + stateChanged.oldState + " to " + stateChanged.newState);
                    playerState = stateChanged.newState;
                    updatePlayerState(stateChanged.newState.toString());
                }
            }
        });
//        player.addEventListener(new PKEvent.Listener() {
//            @Override
//            public void onEvent(PKEvent event) {
//                //When the track data available, this event occurs. It brings the info object with it.
//                PlayerEvent.TracksAvailable tracksAvailable = (PlayerEvent.TracksAvailable) event;
//                populateSpinnersWithTrackInfo(tracksAvailable.tracksInfo);
//
//            }
//        }, PlayerEvent.Type.TRACKS_AVAILABLE);

        player.addEventListener(new PKEvent.Listener() {
            @Override
            public void onEvent(PKEvent event) {
                //When the track data available, this event occurs. It brings the info object with it.
                PlayerEvent.PlayheadUpdated playheadUpdated = (PlayerEvent.PlayheadUpdated) event;
                Log.d(TAG,"playheadUpdated event  position = " + playheadUpdated.position + " duration = " + playheadUpdated.duration);
                updatePlayerTime(playheadUpdated.position);
            }
        }, PlayerEvent.Type.PLAYHEAD_UPDATED);
    }


    /**
     * Will create {@link } object.
     */
    private void createMediaConfig(Map playerConfig) {
        //First. Create PKMediaConfig object.
        mediaConfig = new PKMediaConfig();

        //Set start position of the media. This will
        //automatically start playback from specified position.
        mediaConfig.setStartPosition(0)
                .setMediaEntry(createMediaEntry(playerConfig));
    }

    /**
     * Create {@link PKMediaEntry} with minimum necessary data.
     *
     * @return - the {@link PKMediaEntry} object.
     */
    private PKMediaEntry createMediaEntry(Map playerConfig) {
        //Create media entry.
        PKMediaEntry mediaEntry = new PKMediaEntry();

        //Set id for the entry.
        mediaEntry.setId((String) playerConfig.get("entryId"));

        //Set media entry type. It could be Live,Vod or Unknown.
        //In this sample we use Vod.
        mediaEntry.setMediaType(PKMediaEntry.MediaEntryType.Vod);

        //Create list that contains at least 1 media source.
        //Each media entry can contain a couple of different media sources.
        //All of them represent the same content, the difference is in it format.
        //For example same entry can contain PKMediaSource with dash and another
        // PKMediaSource can be with hls. The player will decide by itself which source is
        // preferred for playback.
        List<PKMediaSource> mediaSources = createMediaSources((JSONArray) playerConfig.get("sources"));

        //Set media sources to the entry.
        mediaEntry.setSources(mediaSources);

        return mediaEntry;
    }

    /**
     * Create list of {@link PKMediaSource}.
     *
     * @return - the list of sources.
     */
    private List<PKMediaSource> createMediaSources(JSONArray sources) {
        //Init list which will hold the PKMediaSources.
        List<PKMediaSource> mediaSources = new ArrayList<>();


        for (Object object : sources) {
            try {
                JSONObject jsonObject = (JSONObject) object;
                //Create new PKMediaSource instance.
                PKMediaSource mediaSource = new PKMediaSource();

                //Set the id.
                mediaSource
                        .setId(jsonObject.getString("id"))
                        .setUrl(jsonObject.getString("contentUrl"))
                        .setMediaFormat(PKMediaFormat.hls);

                //Add media source to the list.
                mediaSources.add(mediaSource);
            } catch (JSONException e) {
                Log.d(TAG, "Could not parse media entry:" + e.getMessage());
                continue;
            }
        }

        return mediaSources;
    }

}

