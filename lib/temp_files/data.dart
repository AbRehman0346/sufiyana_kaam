import '../models/process-task.dart';
import '../models/process.dart';

class Data {
  ProcessTaskFields f = ProcessTaskFields();
  Priority p = Priority();
  ProcessTaskStatus s = ProcessTaskStatus();
  int processId = 1;
  List get data => [
    {
      f.title: "NF: The State VS Sikandar Ali Siyal *",
      f.description: "2nd ADJ NF\n6/8",
      f.date: "August 27, 2025",
      f.time: "",
      f.priority: Priority.getValue(p.normal),
      f.status: ProcessTaskStatus.pending,
      f.processId: processId,
    },

    {
      f.title: "NF: The State VS Gulzar Sahto",
      f.description: "1st ADJ NF\n07/8",
      f.date: "August 20, 2025",
      f.time: "",
      f.priority: Priority.getValue(p.normal),
      f.status: ProcessTaskStatus.pending,
      f.processId: processId,
    },

    {
      f.title: "Mehrabpur: Niaz Hussain VS Imtiaz and others *",
      f.description: "SCJ Mehrabpur\n6/8\n0308 3252315 --> Imtiaz Noohpoth",
      f.date: "August 13, 2025",
      f.time: "",
      f.priority: Priority.getValue(p.normal),
      f.status: ProcessTaskStatus.pending,
      f.processId: processId,
    },

    {
      f.title: "Sukkur: Raja Ali * VS The State",
      f.description: "High Court Sukkur\n21/7",
      f.date: "August 21, 2025",
      f.time: "",
      f.priority: Priority.getValue(p.normal),
      f.status: ProcessTaskStatus.pending,
      f.processId: processId,
    },

    {
      f.title: "Sukkur: Sajjad Ali Siyal VS The State",
      f.description: "High Court Sukkur\n20/7",
      f.date: "August 19, 2025",
      f.time: "",
      f.priority: Priority.getValue(p.normal),
      f.status: ProcessTaskStatus.pending,
      f.processId: processId,
    },

    {
      f.title: "NF: The State VS Sajjad Siyal",
      f.description: "Session Court NF",
      f.date: "August 16, 2025",
      f.time: "",
      f.priority: Priority.getValue(p.normal),
      f.status: ProcessTaskStatus.pending,
      f.processId: processId,
    },

    {
      f.title: "Moro: The State VS Peeral Mallah *",
      f.description: "1st JM Moro\n1/8",
      f.date: "August 15, 2025",
      f.time: "",
      f.priority: Priority.getValue(p.normal),
      f.status: ProcessTaskStatus.pending,
      f.processId: processId,
    },

    {
      f.title: "NF: Mukhtiar Ahmed VS Mst. Bhanbhan *",
      f.description: "2nd ADJ NF\n28/6",
      f.date: "August 9, 2025",
      f.time: "",
      f.priority: Priority.getValue(p.normal),
      f.status: ProcessTaskStatus.pending,
      f.processId: processId,
    },

    {
      f.title: "Gambat: Fida Hussain VS P.O Sindh *",
      f.description: "SCJ Gambat\n14/6",
      f.date: "August 9, 2025",
      f.time: "",
      f.priority: Priority.getValue(p.normal),
      f.status: ProcessTaskStatus.pending,
      f.processId: processId,
    },

    {
      f.title: "Gambat: Ali Sher VS Fida Hussain *",
      f.description: "SCJ Gambat\n14/6",
      f.date: "August 9, 2025",
      f.time: "",
      f.priority: Priority.getValue(p.normal),
      f.status: ProcessTaskStatus.pending,
      f.processId: processId,
    },

    {
      f.title: "NF: The State VS Jinsar Ali Mangi",
      f.description: "Session Court NF",
      f.date: "August 8, 2025",
      f.time: "",
      f.priority: Priority.getValue(p.normal),
      f.status: ProcessTaskStatus.completed,
      f.processId: processId,
    },


    {
      f.title: "NF: Ali Muhammand VS Sain Bux *",
      f.description: "SCJ NF\n23/6",
      f.date: "August 8, 2025",
      f.time: "",
      f.priority: Priority.getValue(p.normal),
      f.status: ProcessTaskStatus.completed,
      f.processId: processId,
    },

    {
      f.title: "NF: The State VS Gulzar Sahto",
      f.description: "1st ADJ NF\n16/7",
      f.date: "August 7, 2025",
      f.time: "",
      f.priority: Priority.getValue(p.normal),
      f.status: ProcessTaskStatus.completed,
      f.processId: processId,
    },

    {
      f.title: "NF: Shamshad VS Abid",
      f.description: "Session Court NF\n27/6\ntransfered to ADJ-1",
      f.date: "August 7, 2025",
      f.time: "",
      f.priority: Priority.getValue(p.normal),
      f.status: ProcessTaskStatus.completed,
      f.processId: processId,
    },

    {
      f.title: "NF: The State VS Sikandar Ali Siyal *",
      f.description: "2nd ADJ NF\n23/7",
      f.date: "August 5, 2025",
      f.time: "",
      f.priority: Priority.getValue(p.normal),
      f.status: ProcessTaskStatus.completed,
      f.processId: processId,
    },

    {
      f.title: "NF: The State VS Sikandar Ali Siyal *",
      f.description: "2nd ADJ NF\n5/8",
      f.date: "August 6, 2025",
      f.time: "",
      f.priority: Priority.getValue(p.normal),
      f.status: ProcessTaskStatus.completed,
      f.processId: processId,
    },

    {
      f.title: "NF: The State VS Ali Raza Larai *",
      f.description: "1st ADJ NF\n05/07",
      f.date: "August 22, 2025",
      f.time: "",
      f.priority: Priority.getValue(p.normal),
      f.status: ProcessTaskStatus.pending,
      f.processId: processId,
    },

    {
      f.title: "Mehrabpur: Niaz Hussain VS Imtiaz *",
      f.description: "SCJ Mehrabpur\n25/06\n0308 3252315 --> Imtiaz Noohpoth",
      f.date: "August 6, 2025",
      f.time: "",
      f.priority: Priority.getValue(p.normal),
      f.status: ProcessTaskStatus.completed,
      f.processId: processId,
    },

    {
      f.title: "NF: The State VS Sikandar Ali Siyal",
      f.description: "1st ADJ NF\n05/08",
      f.date: "August 21, 2025",
      f.time: "",
      f.priority: Priority.getValue(p.normal),
      f.status: ProcessTaskStatus.pending,
      f.processId: processId,
    },


    {
      f.title: "Gambat: Mst. Izzat Khatoon VS Rahmatullah *",
      f.description: "SCJ Gambat\n14/06",
      f.date: "August 6, 2025",
      f.time: "",
      f.priority: Priority.getValue(p.normal),
      f.status: ProcessTaskStatus.cancelled,
      f.processId: processId,
    },

    {
      f.title: "NF: The State VS Rizwan Tagar",
      f.description: "1st JM NF\n10/07",
      f.date: "August 5, 2025",
      f.time: "",
      f.priority: Priority.getValue(p.normal),
      f.status: ProcessTaskStatus.cancelled,
      f.processId: processId,
    },

    {
      f.title: "NF: Shamshad VS Abid",
      f.description: "ADJ 1 NF\n07/08",
      f.date: "August 19, 2025",
      f.time: "",
      f.priority: Priority.getValue(p.normal),
      f.status: ProcessTaskStatus.pending,
      f.processId: processId,
    },

    {
      f.title: "Kandiro: Abdul Haleem VS Nadra *",
      f.description: "1st JM Kandiro",
      f.date: "August 11, 2025",
      f.time: "",
      f.priority: Priority.getValue(p.normal),
      f.status: ProcessTaskStatus.pending,
      f.processId: processId,
    },

    {
      f.title: "NF: Ali Muhammad VS Sain Bux *",
      f.description: "SCJ NF\n08/08",
      f.date: "August 27, 2025",
      f.time: "",
      f.priority: Priority.getValue(p.normal),
      f.status: ProcessTaskStatus.pending,
      f.processId: processId,
    },

    {
      f.title: "NF: Muhammad Adam VS SSP NF",
      f.description: "Family Court\n08/08",
      f.date: "August 28, 2025",
      f.time: "",
      f.priority: Priority.getValue(p.normal),
      f.status: ProcessTaskStatus.pending,
      f.processId: processId,
    },

    {
      f.title: "NF: The State VS Jinsar Ali Mangi",
      f.description: "Session Court NF\n08/08",
      f.date: "August 28, 2025",
      f.time: "",
      f.priority: Priority.getValue(p.normal),
      f.status: ProcessTaskStatus.pending,
      f.processId: processId,
    },
  ];
}