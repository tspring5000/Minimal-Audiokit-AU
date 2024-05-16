#  Minimal Audiokit AU Example
Due to a lack of documentation on creating Audio Units, especially with AudioKit, I thought this example might be helpful to some people

This is the most minimal example I could build, it's a generator (audio-out only, not midi or audio-in), it does not use parameters, just swiftui. Of course you will want to extend it, but hopefully it's a more helpful starting point than Apples own cpp DSP based template

We reuse a lot of the components built for the main app itself, including the UI, and the MainUIView is nearly an exact copy of the main apps ContentView

The entire AU is written in swift, aside from `MinimalAU/UI/Base.lprog/MainInterface` which can be copied over from the standard apple template (`common/UI/`) and does not need any modification

Apologies for the lack of git history, there was some issues on an old repo and I thought it'd just be cleaner to migrate to a new one
