import ballerina.lang.messages;
import ballerina.lang.system;
import ballerina.net.jms;

@jms:config {
    initialContextFactory:"wso2mbInitialContextFactory",
    providerUrl:
           "amqp://admin:admin@carbon/carbon?brokerlist='tcp://localhost:5672'",
    connectionFactoryType:"queue",
    connectionFactoryName:"QueueConnectionFactory",
    destination:"MyQueue",
    acknowledgmentMode:"AUTO_ACKNOWLEDGE"
}
service<jms> jmsService {
    resource onMessage (message m) {
        // Read a message property.
        string myProperty = messages:getProperty(m, "MyProperty");
        // Print the property values
        system:println("myProperty value " + myProperty);

        message responseMessage = {};
        // Set a custom message property. This value will be treated as a JMS 
        // message string property when sending to a JMS provider
        messages:setProperty(responseMessage, "MySecondProperty", 
                                              "Hello from Ballerina!");

        map properties = {
                         "initialContextFactory":"wso2mbInitialContextFactory",
                         "configFilePath":"../jndi.properties",
                         "connectionFactoryName": "QueueConnectionFactory",
                         "connectionFactoryType" :"queue"};

        jms:ClientConnector jmsEP = create jms:ClientConnector(properties);
        jms:ClientConnector.send(jmsEP, "MySecondQueue", responseMessage);

    }
}

