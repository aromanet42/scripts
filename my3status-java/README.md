## I3Bar status - Java version


I3 bar is fully customizable.

This is a Java module to build the I3 Bar.

Logs are in _/tmp/logs/my3status.log_

### Java native

As the I3 bar is run at the very startup of the session, the PATH is not full.
For example, there is not Java neither Maven in the classpath,
and I could not find a way to add them.
We cannot use Docker image for I3Bar, as we want the container to trigger command on the host machine.

That's why this module is compiled as a Native image.
This means that the produced artifact will be standalone, and will not depend on Maven or Java.
We still need Maven and Java to build this image,
but not for running it.

In this module, we will use `org.graalvm.buildtools:native-maven-plugin`
defined in `spring-boot-starter-parent` in the `native` maven profile.

When modifying the Java code, you must re-create the image:
```shell
mvn -Pnative clean native:compile
```



### Updating I3 bar items

See `fr.aromanet42.my3status.I3BarService#bar` to update displayed items.

Each resource must build one or multiple `fr.aromanet42.my3status.bar.I3BarItem`.

One item must defined at least a `name` and a `full_text`.

Items can also defined on `onClick` command that will be triggered when user will click on the I3 Bar.

### Running locally

You can run the module locally.

Use `development` profile:
- to have logs in the console (instead of file)
- to disable scheduled items, and only trigger the item you want to debug.
  See `fr.aromanet42.my3status.Runner#run` to see how to trigger a specific item. 
