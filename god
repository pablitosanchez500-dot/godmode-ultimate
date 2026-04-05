const express = require("express");
const fetch = require("node-fetch");
const app = express();
const PORT = process.env.PORT || 3000;

// Tu API Key de OddsPapi como variable de entorno
const ODDS_API_KEY = process.env.ODDS_API_KEY;

app.use(express.static("public"));

// Endpoint para traer cuotas desde OddsPapi
app.get("/api/odds", async (req, res) => {
  try {
    const response = await fetch(`https://api.oddspapi.io/v4/odds?sportId=10&apiKey=${ODDS_API_KEY}`);
    const data = await response.json();
    res.json(data);
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: "Error al obtener cuotas" });
  }
});

app.listen(PORT, () => console.log(`Servidor iniciado en puerto ${PORT}`));

{
  "name": "godmode-ultimate",
  "version": "1.0.0",
  "main": "index.js",
  "dependencies": {
    "express": "^4.18.2",
    "node-fetch": "^3.3.2"
  },
  "scripts": {
    "start": "node index.js"
  }
}

<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Matched Betting GOD MODE</title>
<style>
body { font-family: Arial; background:#0b0b0b; color:white; padding:20px; }
.container { max-width:1100px; margin:auto; background:#1a1a1a; padding:20px; border-radius:12px; }
h2 { color:#00ffcc; }
input, select { padding:8px; margin:5px; width:130px; }
button { padding:10px; margin:5px; cursor:pointer; border-radius:8px; }
.result { background:#111; padding:15px; margin-top:15px; border-radius:10px; }
.card { background:#151515; padding:15px; border-radius:10px; margin-top:15px; }
.good{color:#00ff00;} .ok{color:#ffd700;} .bad{color:#ff4d4d;}
</style>
</head>
<body>

<div class="container">
<h2>💰 Matched Betting GOD MODE</h2>

<div class="card">
<h3>🎯 Calculadora inteligente</h3>
<select id="tipo">
<option value="freebet">Freebet</option>
<option value="normal">Normal</option>
</select>
<input type="number" id="stake" value="10" placeholder="Stake">
<input type="number" id="back" value="5" placeholder="Back">
<input type="number" id="lay" value="5.2" placeholder="Lay">
<input type="number" id="com" value="5" placeholder="Comisión %">
<button onclick="analizar()">🤖 Analizar</button>
</div>

<div id="res" class="result"></div>

<div class="card">
<h3>🤖 Decisión automática</h3>
<div id="decision"></div>
</div>

<div class="card">
<h3>📈 Simulador PRO</h3>
<div id="sim"></div>
</div>

<div class="card">
<h3>📊 Objetivo diario</h3>
<input type="number" id="objetivo" value="20"> € / día
<button onclick="calcularObjetivo()">Calcular plan</button>
<div id="plan"></div>
</div>

</div>

<script>
async function analizar(){
 let stake = parseFloat(stakeEl.value)||0;
 let back = parseFloat(backEl.value)||0;
 let lay = parseFloat(layEl.value)||0;
 let com = (parseFloat(comEl.value)||0)/100;
 let tipo = tipoEl.value;

 if(back<=1||lay<=1){ res.innerHTML="❌ Cuotas inválidas"; return; }

 let layStake, liability, win, lose;

 if(tipo==="freebet"){
  layStake = (stake*(back-1))/(lay-com);
  liability = layStake*(lay-1);
  win = (stake*(back-1))-liability;
  lose = layStake*(1-com);
 } else {
  layStake = (stake*back)/(lay-com);
  liability = layStake*(lay-1);
  win = (stake*(back-1))-liability;
  lose = (layStake*(1-com))-stake;
 }

 let media=(win+lose)/2;
 let roi=(media/liability)*100;
 let conv=(tipo==="freebet")?(media/stake)*100:0;
 let spread=lay-back;

 let color = media>0?"good":"bad";

 res.innerHTML=`
 Lay stake: ${layStake.toFixed(2)}€<br>
 Liability: ${liability.toFixed(2)}€<br>
 <b class="${color}">Beneficio medio: ${media.toFixed(2)}€</b><br>
 ROI: ${roi.toFixed(1)}%<br>
 Conversión: ${conv.toFixed(1)}%<br>
 Spread: ${spread.toFixed(2)}
 `;

 let decisionTxt="";
 if(conv>80 && spread<0.25) decisionTxt="🔥 ENTRA YA (nivel dios)";
 else if(conv>70) decisionTxt="👍 BUENA";
 else if(conv>60) decisionTxt="⚖️ ESPERAR";
 else decisionTxt="❌ PASAR";

 decision.innerHTML = decisionTxt;

 let mejores=[];
 for(let i=0;i<5;i++){
  let testLay = lay - (i*0.1);
  let testConv = ((stake*(back-1))/(testLay-com))/stake*100;
  mejores.push(`Lay ${testLay.toFixed(2)} → ${testConv.toFixed(1)}%`);
 }
 sim.innerHTML = mejores.join("<br>");
 window.lastMedia = media;
}

function calcularObjetivo(){
 let objetivo = parseFloat(objetivoEl.value)||0;
 let media = window.lastMedia || 5;
 let necesarias = objetivo / media;
 plan.innerHTML = `
 Necesitas aprox <b>${Math.ceil(necesarias)}</b> apuestas al día<br>
 Beneficio medio actual: ${media.toFixed(2)}€
 `;
}

const stakeEl = document.getElementById('stake');
const backEl = document.getElementById('back');
const layEl = document.getElementById('lay');
const comEl = document.getElementById('com');
const tipoEl = document.getElementById('tipo');
const res = document.getElementById('res');
const decision = document.getElementById('decision');
const sim = document.getElementById('sim');
const objetivoEl = document.getElementById('objetivo');
const plan = document.getElementById('plan');
</script>

</body>
</html>
