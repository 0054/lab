FROM jenkins/jenkins:lts

#ENV JAVA_OPTS "-Djenkins.install.runSetupWizard=false -Dpermissive-script-security.enabled=true"
ENV CASC_JENKINS_CONFIG=/var/jenkins_home/jenkins.yaml
# RUN /usr/local/bin/install-plugins.sh configuration-as-code matrix-auth cloudbees-folder
COPY plugins.txt .
RUN /usr/local/bin/install-plugins.sh < plugins.txt
# RUN for plugin in "cloudbees-folder configuration-as-code matrix-auth"; do \
#     /usr/local/bin/install-plugins.sh $plugin; \
#     done
    
COPY ./jenkins.yml /var/jenkins_home/jenkins.yaml


