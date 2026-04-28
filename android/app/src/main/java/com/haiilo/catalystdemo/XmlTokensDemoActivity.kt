package com.haiilo.catalystdemo

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity

class XmlTokensDemoActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.sample_catalyst_tokens)
        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        supportActionBar?.title = "XML Tokens Demo"
    }

    override fun onSupportNavigateUp(): Boolean {
        onBackPressedDispatcher.onBackPressed()
        return true
    }
}

