//
// Copyright (C) 2008 Christoph Sommer <christoph.sommer@informatik.uni-erlangen.de>
//
// Documentation for these modules is at http://veins.car2x.org/
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
//

package edu.ncsu.vanet.vanet_aodv;

import org.mixim.base.modules.*;
import org.mixim.modules.nic.Nic80211p;
import inet.networklayer.ipv4.RoutingTable;
import inet.networklayer.manetrouting.AODVUU;
import inet.nodes.inet.NetworkLayer;
import inet.applications.IPingApp;
import inet.applications.PingApp;
import inet.networklayer.autorouting.ipv4.IPv4NetworkConfigurator;
module Car
{
    parameters:
        string applType; //type of the application layer
        string mobilityType; //type of the mobility module
	int numPingApps = default(1); // Number of ping apps.
    gates:
        input radioIn; // gate for sendDirect
    submodules:
        appl: <applType> like IBaseApplLayer {
            parameters:
                @display("p=60,50");
        }

 	pingApp[numPingApps]: <default("PingApp")> like IPingApp {
            parameters:
                @display("p=635,141,row,60");
        }

        arp: BaseArp {
            parameters:
                @display("p=130,108");
        }

        //Added AODV
        manetrouting: AODVUU {
            parameters:
                @display("p=60,100");
        }

        // Added network layer
        networkLayer: NetworkLayer {
            parameters:
                @display("p=329,287;q=queue");
	    gates:
		ifIn[1];
		ifOut[1];
        }
	// Added configurator
        configurator: IPv4NetworkConfigurator {
            parameters:
                config=xml("<config><interface hosts='*' address='145.236.x.x' netmask='255.255.0.0'/></config>");
                @display("p=140,50;i=block/cogwheel_s");
        }


        nic: Nic80211p {
            parameters:
                @display("p=60,166");
        }

        mobility: <mobilityType> like IMobility {
            parameters:
                @display("p=130,172;i=block/cogwheel");
        }
    connections allowunconnected:
        radioIn --> nic.radioIn;

        nic.upperLayerOut --> networkLayer.ifIn[0];
        nic.upperLayerIn <-- networkLayer.ifOut[0];
   
        networkLayer.transportOut++ --> manetrouting.from_ip;
        networkLayer.transportIn++ <-- manetrouting.to_ip;

        networkLayer.transportOut++ --> appl.lowerLayerIn;
        networkLayer.transportIn++ <-- appl.lowerLayerOut; 

	//Not sure.
   	nic.upperControlOut --> appl.lowerControlIn;
        nic.upperControlIn <-- appl.lowerControlOut;
 	for i=0..numPingApps-1 {
            networkLayer.pingOut++ --> pingApp[i].pingIn;
            networkLayer.pingIn++ <-- pingApp[i].pingOut;
        }
}
