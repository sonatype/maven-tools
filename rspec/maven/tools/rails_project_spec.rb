require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper.rb'))
require 'maven/tools/rails_project'

describe Maven::Tools::RailsProject do

  before :each do
    @project = Maven::Tools::RailsProject.new("test")
  end
  
  it 'should load Gemfile from a simple rails application with applied defaults' do
    pending "hash is differently orderd in ruby1.8" if RUBY_VERSION =~ /^1.8/ && !defined? JRUBY_VERSION
    @project.load_gemfile(File.join(File.dirname(__FILE__), 'Gemfile.simple'))
    @project.name "test"
    @project.add_defaults
    @project.to_xml.should == <<-XML
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>rails</groupId>
  <artifactId>test</artifactId>
  <version>0.0.0</version>
  <name><![CDATA[test]]></name>
  <packaging>war</packaging>
  <repositories>
    <repository>
      <id>rubygems-releases</id>
      <url>http://rubygems-proxy.torquebox.org/releases</url>
    </repository>
    <repository>
      <id>rubygems-prereleases</id>
      <url>http://rubygems-proxy.torquebox.org/prereleases</url>
      <releases>
        <enabled>false</enabled>
      </releases>
      <snapshots>
        <enabled>true</enabled>
      </snapshots>
    </repository>
  </repositories>
  <dependencies>
    <dependency>
      <groupId>rubygems</groupId>
      <artifactId>rails</artifactId>
      <version>3.0.1</version>
      <type>gem</type>
    </dependency>
#{ !defined?(JRUBY_VERSION) ? '' : '    <dependency>
      <groupId>rubygems</groupId>
      <artifactId>activerecord-jdbc-adapter</artifactId>
      <version>[0,)</version>
      <type>gem</type>
    </dependency>
'
}    <dependency>
      <groupId>rubygems</groupId>
      <artifactId>#{ defined?(JRUBY_VERSION) ? 'jdbc-' : ''}sqlite3</artifactId>
      <version>[0,)</version>
      <type>gem</type>
    </dependency>
    <dependency>
      <groupId>rubygems</groupId>
      <artifactId>bundler</artifactId>
      <type>gem</type>
    </dependency>
    <dependency>
      <groupId>org.jruby</groupId>
      <artifactId>jruby-complete</artifactId>
      <version>${jruby.version}</version>
      <type>jar</type>
    </dependency>
    <dependency>
      <groupId>org.jruby.rack</groupId>
      <artifactId>jruby-rack</artifactId>
      <version>_jruby.rack.version_</version>
      <type>jar</type>
    </dependency>
  </dependencies>
  <dependencyManagement>
    <dependencies>
      <dependency>
        <groupId>rubygems</groupId>
        <artifactId>bundler</artifactId>
        <version>_bundler.version_</version>
        <type>gem</type>
      </dependency>
    </dependencies>
  </dependencyManagement>
  <properties>
    <gem.home>${project.build.directory}/rubygems</gem.home>
    <gem.includeRubygemsInTestResources>false</gem.includeRubygemsInTestResources>
    <gem.path>${project.build.directory}/rubygems</gem.path>
    <jetty.version>_jetty.version_</jetty.version>
    <jruby.plugins.version>_project.version_</jruby.plugins.version>
    <jruby.version>_jruby.version_</jruby.version>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <rails.env>development</rails.env>
  </properties>
  <build>
    <plugins>
      <plugin>
        <groupId>de.saumya.mojo</groupId>
        <artifactId>bundler-maven-plugin</artifactId>
        <version>${jruby.plugins.version}</version>
      </plugin>
      <plugin>
        <groupId>de.saumya.mojo</groupId>
        <artifactId>rails3-maven-plugin</artifactId>
        <version>${jruby.plugins.version}</version>
        <executions>
          <execution>
            <id>in_phase_validate</id>
            <phase>validate</phase>
            <goals>
              <goal>initialize</goal>
            </goals>
          </execution>
        </executions>
      </plugin>
      <plugin>
        <artifactId>maven-war-plugin</artifactId>
        <version>_war.version_</version>
        <configuration>
          <webResources>
            <resource>
              <directory>public</directory>
            </resource>
            <resource>
              <directory>.</directory>
              <includes>
                <include>app/**</include>
                <include>config/**</include>
                <include>lib/**</include>
                <include>vendor/**</include>
                <include>Gemfile</include>
              </includes>
              <targetPath>WEB-INF</targetPath>
            </resource>
            <resource>
              <directory>${gem.path}</directory>
              <includes>
                <include>gems/**</include>
                <include>specifications/**</include>
              </includes>
              <targetPath>WEB-INF/gems</targetPath>
            </resource>
          </webResources>
        </configuration>
      </plugin>
    </plugins>
    <pluginManagement>
      <plugins>
        <plugin>
          <groupId>org.eclipse.m2e</groupId>
          <artifactId>lifecycle-mapping</artifactId>
          <version>1.0.0</version>
          <configuration>
            <lifecycleMappingMetadata>
              <pluginExecutions>
                <pluginExecution>
                  <action>
                    <ignore></ignore>
                  </action>
                  <pluginExecutionFilter>
                    <artifactId>bundler-maven-plugin</artifactId>
                    <goals>
                      <goal>install</goal>
                    </goals>
                    <groupId>de.saumya.mojo</groupId>
                    <versionRange>[0,)</versionRange>
                  </pluginExecutionFilter>
                </pluginExecution>
              </pluginExecutions>
            </lifecycleMappingMetadata>
          </configuration>
        </plugin>
      </plugins>
    </pluginManagement>
  </build>
  <profiles>
    <profile>
      <id>assets</id>
      <activation>
        <activeByDefault>true</activeByDefault>
      </activation>
    </profile>
    <profile>
      <id>development</id>
      <activation>
        <activeByDefault>true</activeByDefault>
      </activation>
    </profile>
    <profile>
      <id>test</id>
      <activation>
        <property>
          <name>rails.env</name>
          <value>test</value>
        </property>
      </activation>
    </profile>
    <profile>
      <id>production</id>
      <activation>
        <property>
          <name>rails.env</name>
          <value>production</value>
        </property>
      </activation>
      <properties>
        <gem.home>${project.build.directory}/rubygems-production</gem.home>
        <gem.path>${project.build.directory}/rubygems-production</gem.path>
      </properties>
    </profile>
    <profile>
      <id>war</id>
      <build>
        <plugins>
          <plugin>
            <groupId>org.mortbay.jetty</groupId>
            <artifactId>jetty-maven-plugin</artifactId>
            <version>${jetty.version}</version>
          </plugin>
        </plugins>
      </build>
    </profile>
    <profile>
      <id>run</id>
      <activation>
        <activeByDefault>true</activeByDefault>
      </activation>
      <build>
        <plugins>
          <plugin>
            <groupId>org.mortbay.jetty</groupId>
            <artifactId>jetty-maven-plugin</artifactId>
            <version>${jetty.version}</version>
            <configuration>
              <connectors>
                <connector implementation="org.eclipse.jetty.server.nio.SelectChannelConnector">
                  <port>8080</port>
                </connector>
                <connector implementation="org.eclipse.jetty.server.ssl.SslSelectChannelConnector">
                  <port>8443</port>
                  <keystore>${project.basedir}/src/test/resources/server.keystore</keystore>
                  <keyPassword>123456</keyPassword>
                  <password>123456</password>
                </connector>
              </connectors>
              <systemProperties>
                <systemProperty>
                  <name>jbundle.skip</name>
                  <value>true</value>
                </systemProperty>
              </systemProperties>
              <webAppConfig>
                <overrideDescriptor>${project.build.directory}/jetty/override-${rails.env}-web.xml</overrideDescriptor>
              </webAppConfig>
            </configuration>
          </plugin>
        </plugins>
      </build>
    </profile>
    <profile>
      <id>warshell</id>
      <pluginRepositories>
        <pluginRepository>
          <id>kos</id>
          <url>http://opensource.kantega.no/nexus/content/groups/public/</url>
        </pluginRepository>
      </pluginRepositories>
      <build>
        <plugins>
          <plugin>
            <groupId>org.simplericity.jettyconsole</groupId>
            <artifactId>jetty-console-maven-plugin</artifactId>
            <version>1.42</version>
            <executions>
              <execution>
                <goals>
                  <goal>createconsole</goal>
                </goals>
                <configuration>
                <!--
                                  see http://simplericity.com/2009/11/10/1257880778509.html for more info
                -->
                <!--
		  <backgroundImage>${basedir}/src/main/jettyconsole/puffin.jpg</backgroundImage>
		  <additionalDependencies>
		    <additionalDependency>
		      <artifactId>jetty-console-winsrv-plugin</artifactId>
		    </additionalDependency>
		    <additionalDependency>
		      <artifactId>jetty-console-requestlog-plugin</artifactId>
		    </additionalDependency>
		    <additionalDependency>
		      <artifactId>jetty-console-log4j-plugin</artifactId>
		    </additionalDependency>
		    <additionalDependency>
		      <artifactId>jetty-console-jettyxml-plugin</artifactId>
		    </additionalDependency>
		    <additionalDependency>
		      <artifactId>jetty-console-ajp-plugin</artifactId>
		    </additionalDependency>
		    <additionalDependency>
		      <artifactId>jetty-console-gzip-plugin</artifactId>
		    </additionalDependency>
		    <additionalDependency>
		      <artifactId>jetty-console-startstop-plugin</artifactId>
		    </additionalDependency>
		  </additionalDependencies>

                -->
                </configuration>
              </execution>
            </executions>
          </plugin>
        </plugins>
      </build>
    </profile>
  </profiles>
</project>
XML
  end

  it 'should load Gemfile from a rails application"' do
    pending "hash is differently orderd in ruby1.8" if RUBY_VERSION =~ /^1.8/ && !defined? JRUBY_VERSION
    @project.load_gemfile(File.join(File.dirname(__FILE__), 'Gemfile.rails'))
    @project.to_xml.should == <<-XML
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>rails</groupId>
  <artifactId>test</artifactId>
  <version>0.0.0</version>
  <packaging>war</packaging>
  <dependencies>
    <dependency>
      <groupId>rubygems</groupId>
      <artifactId>rails</artifactId>
      <version>3.0.1</version>
      <type>gem</type>
    </dependency>
#{ !defined?(JRUBY_VERSION) ? '' : '    <dependency>
      <groupId>rubygems</groupId>
      <artifactId>activerecord-jdbc-adapter</artifactId>
      <version>[0,)</version>
      <type>gem</type>
    </dependency>
' 
}  </dependencies>
  <build>
    <plugins>
      <plugin>
        <groupId>de.saumya.mojo</groupId>
        <artifactId>bundler-maven-plugin</artifactId>
      </plugin>
    </plugins>
  </build>
  <profiles>
    <profile>
      <id>development</id>
      <dependencies>
        <dependency>
          <groupId>rubygems</groupId>
          <artifactId>#{ defined?(JRUBY_VERSION) ? 'jdbc-' : ''}sqlite3</artifactId>
          <version>[0,)</version>
          <type>gem</type>
        </dependency>
        <dependency>
          <groupId>rubygems</groupId>
          <artifactId>rspec</artifactId>
          <version>[0,)</version>
          <type>gem</type>
        </dependency>
      </dependencies>
    </profile>
    <profile>
      <id>test</id>
      <dependencies>
        <dependency>
          <groupId>rubygems</groupId>
          <artifactId>rspec</artifactId>
          <version>[0,)</version>
          <type>gem</type>
        </dependency>
      </dependencies>
    </profile>
    <profile>
      <id>production</id>
      <dependencies>
        <dependency>
          <groupId>rubygems</groupId>
          <artifactId>#{ defined?(JRUBY_VERSION) ? 'jdbc-' : ''}mysql</artifactId>
          <version>[0,)</version>
          <type>gem</type>
        </dependency>
      </dependencies>
    </profile>
  </profiles>
</project>
XML
  end
end
