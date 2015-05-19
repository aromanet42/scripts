# environment variables

export HISTTIMEFORMAT='%F %T ' # show history with datetime





alias jdk6="rm -f $DEV/current_jdk; ln -s $DEV/jdk1.6.0_45 $DEV/current_jdk"
alias jdk8="rm -f $DEV/current_jdk; ln -s $DEV/jdk1.8.0_20 $DEV/current_jdk"



export JAVA_HOME=$DEV/current_jdk
export GRAILS_HOME=$DEV/grails
export MAVEN_HOME=$DEV/apache-maven
export CATALINA_HOME=$DEV/apache-tomcat
    

export PATH="$PATH:$JAVA_HOME/bin:$GRAILS_HOME/bin:$MAVEN_HOME/bin:$CATALINA_HOME/bin:$SHARED_TOOLS/scripts:~/.xmonad/bin"
  


