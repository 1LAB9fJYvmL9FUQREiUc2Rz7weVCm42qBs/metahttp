- Q: Why does this github account have such a complicated name? Almost looks like a bitcoin address?  
  A: It ***is*** a bitcoin address. We wanted to keep this account anonymous, while still keeping the option to go non-anonymous in the future.
     How does that work? Well, the name anonymous@github.com was already taken, so we could'nt go with that one:smirk:  On the other hand, when you create a bitcoin (or any other crypto) key pair on your own, then you create something unique that cannot be linked to any physical identity. Even when you expose the public key to the public. But the nicest takeaway is the option to _prove ownership_ in the future: Only we have the private key, so only we can sign messages with that, and thus prove that we are the creators of the content.
 
- Q: What is metahttp?  
  A: Metahttp is a layer above (wrapper around) standard Linux tools that deal with the HTTP(S) protocol: curl, wfuzz, wget (as of version 1.0). It can also create raw HTTP(S) requests.

- Q: What would be the audience of this toolkit?  
  A: Pen testers, students, hacktivists or just people that want to learn the advanced features of wfuzz, wget, curl in a structured manner. We guess that this is not for beginners, because at least you have to be familiar with TCP/IP sockets, Linux pipes, HTTP proxies and the HTTP protocol.

- Q: Why do I need docker to play around with metahttp?  
  A: We figured that the docker approach is the cleanest way to package things: Everything you install just ends up in your docker image, so you have a guarantee that the installation is reversible and you don't mess up anything on your computer. When you don't want metahttp any more, just "docker rmi" your image and everything will be thrown away.

- Q: How do I get started?  
  A: Read README.md and ADVANCED.md  
